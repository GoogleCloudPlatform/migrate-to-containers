#!/bin/bash
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

version=$(curl -s https://mfit-release.storage.googleapis.com/latest)

linux_collect_script=$(curl "https://mfit-release.storage.googleapis.com/$version/mfit-linux-collect.sh")
# Create a script which runs the linux collect script and outputs the resulting archive to STDOUT.
linux_script="
set -e;
script='${linux_collect_script//\'/\'\"\'\"\'}';
sudo -n bash -c \"\$script\" collect-script --output mfit-collect.tar;
encoded_tar=\$(base64 -w0 mfit-collect.tar);
echo '<START_ARCHIVE>';
echo \"\$encoded_tar\";
echo '<END_ARCHIVE>';
"
# Convert the script into a valid json string.
linux_json_escaped=$(echo "$linux_script" | jq -Rsa .)


windows_collect_script=$(curl "https://mfit-release.storage.googleapis.com/$version/mfit-windows-collect.ps1")
# Create a script which runs the windows collect script and outputs the resulting archive to STDOUT.
windows_script="
\$ErrorActionPreference = 'Stop'

Invoke-Command {
$windows_collect_script
} -ArgumentList ('mfit-collect', '--minimal')

try { \$archive = Get-Content -path 'mfit-collect.zip' -Encoding byte }
catch {
	try { \$archive = Get-Content -path 'mfit-collect.tar.gz' -Encoding byte }
	catch { \$archive = Get-Content -path 'mfit-collect.tar' -Encoding byte }
}

\$encoded = [convert]::ToBase64String(\$archive)

Write-Output '<START_ARCHIVE>'
Write-Output \$encoded
Write-Output '<END_ARCHIVE>'
"
# Escape the script according to https://msdn.microsoft.com/en-us/library/ms880421.
# This is needed due to a bug in ssm agent for windows.
windows_escaped_windows_script="\"$(echo "$windows_script" | sed 's/\(\\*\)\"/\1\1\\\"/g')
\"";
# Convert the script into a valid json string.
windows_json_escaped=$(echo "$windows_escaped_windows_script" | jq -Rsa .)

# Find Region if provided, so we can pass it to describe-instances.
for (( i=1; i<=$#; i++)); do
    current=${!i}
    if [ "$current" == "--region" ]; then
      next=$((i+1))
      REGION_FLAG="--region=${!next}";
      break;
    fi

    if [[ "$current" =~ --region=* ]]; then
      REGION_FLAG=$current;
      break;
    fi
done

# For all AWS instances:
aws ssm describe-instance-information "$@" | jq -c '.InstanceInformationList | .[]' | while read instance; do
  id=$(echo "$instance" | jq -r '.InstanceId')
  os=$(echo "$instance" | jq -r '.PlatformType')
  if [ "$os" == "Linux" ]; then
    json_escaped=$linux_json_escaped;
    document="AWS-StartInteractiveCommand"
  elif [ "$os" == "Windows" ]; then
    json_escaped=$windows_json_escaped;
    document="AWS-StartNonInteractiveCommand"
  else
    echo "Instance $id has unsupported platform type $os" >&2;
    continue;
  fi

  echo "Collecting $os VM $id"

  # Run collection via ssm manager.
  result=$(unbuffer aws ssm start-session "$REGION_FLAG" --target $id --document $document --parameters "{ \"command\": [$json_escaped]}");
  # Find the encoded archive between the tags <START_ARCHIVE> and <END_ARCHIVE> by stripping everything before and after those tags.
  encoded=${result#*<START_ARCHIVE>}
  encoded=${encoded%<END_ARCHIVE>*}

  # Check we managed to find the tags - if nothing was stripped, then they weren't found.
  if [ "$encoded" == "$result" ]; then
    echo "Could not extract base64 encoded tar for $id from stdout \"$(echo "$result" | sed -z 's/\n/\\n/g')\"" >&2;
    continue;
  fi

  # Decode the archive, write to a temp file, and import to mfit.
  tmpfile=$(mktemp)
  echo "$encoded" | base64 -di > $tmpfile
  mfit discover import $tmpfile
  rm $tmpfile
done