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

# Parse flags - any named `-a` or `--ssh-arg` are passed to ssh,
# any others are passed directly to aws ec2 describe-instances.
SSH_ARGS=()
OTHER_ARGS=()
while [[ $# -gt 0 ]]; do
  opt="$1"
  if [[ "$opt" == "--ssh-arg" ]] || [[ "$opt" == "-a" ]]; then
    SSH_ARGS+=("-a")
    shift
    SSH_ARGS+=("$1")
  else
    OTHER_ARGS+=("$opt")
  fi
  shift
done

# Generate an ssh key-value pair.
ssh_key_file=$(mktemp -u)
ssh-keygen -t rsa -N '' -f "$ssh_key_file"

# For all AWS instances:
aws ec2 describe-instances "${OTHER_ARGS[@]}" | jq -c '.Reservations | .[] | .Instances | .[]' | while read instance; do
  id=$(echo "$instance" | jq -r '.InstanceId')
  platform=$(echo "$instance" | jq -r '.Platform')
  dns=$(echo "$instance" | jq -r '.PublicDnsName')
  availability_zone=$(echo "$instance" | jq -r '.Placement | .AvailabilityZone')
  state=$(echo "$instance" | jq -r '.State | .Name')

  # By default SSH is not enabled on windows, so skip all windows instances.
  if [[ "$platform" == "windows"  ]]; then
    continue
  fi

  if [[ "$state" != "running" ]]; then
    echo "Instance $id is $state. Skipping" >&2;
    continue
  fi

  if [[ -z "$dns" ]] || [[ "$dns" == "null" ]] ; then
    echo "Instance $id does not have a Public DNS Address. Skipping" >&2;
    continue
  fi

  if [[ -z "$availability_zone" ]] || [[ "$availability_zone" == "null" ]]; then
    echo "Instance $id does not have an availability zone. Skipping" >&2;
    continue
  fi

  echo "Collecting instance $id"

  # Instance connect requires you to provide a valid username for the instance.
  # See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connection-prereqs.html for a list of default usernames.
  # Instance connect only supports Amazon Linux and Ubuntu at the moment, so no need to try usernames for other OSes.
  users=("ec2-user" "ubuntu")
  for user in "${users[@]}"
  do
    # Use aws instance connect to send the public key to the instance
    # It is valid for 60 seconds
    if ! aws ec2-instance-connect send-ssh-public-key \
        --instance-id "$id" \
        --instance-os-user "$user" \
        --availability-zone "$availability_zone" \
        --ssh-public-key "file://${ssh_key_file}.pub"; then
      continue
    fi

    # Run mfit discover ssh.
    # Tee stdout/stderr so we can capture them, but also write them to console.
    out=$(mfit discover ssh -u "$user" "$dns" -i "$ssh_key_file" "${SSH_ARGS[@]}" --connect-timeout 5 2>&1 | tee /dev/fd/2)
    # Permission denied is usually caused by using the incorrect username.
    if [[ "$out" == *"Permission denied"* ]]; then
      message="Permission denied when connecting with username $user."
      if [[ "$user" != "${users[-1]}" ]]; then
        message+=" Retrying with different username..."
      fi
      echo "$message"
    else
      break
    fi
  done
done

# Clean up the generated SSH key.
# This isn't critical, as the keys are invalid after 60s.
rm -f ssh_key_file