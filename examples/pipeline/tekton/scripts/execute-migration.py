#!/usr/bin/env python3
# Copyright 2021 Google LLC
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

import sys
import yaml
import os
import subprocess

templateYAMLPath = sys.argv[1]
migrationName = sys.argv[2]
migrationAppType = sys.argv[3]

execution_name = migrationName + "-exec"

# Load Migration Manifest YAML Template
with open(templateYAMLPath) as m:
    execution_yaml = yaml.load(m, Loader=yaml.SafeLoader)



# Configure YAML
execution_yaml["metadata"]["name"] = execution_name
execution_yaml["spec"]["migration"]["name"] = migrationName
execution_yaml["kind"] = "AppXGenerateArtifactsTask"
# set the flow name
execution_yaml["spec"]["flow"]["name"] = f'appx-generateartifactsflow-{migrationName}'

#if migrationAppType == "system":
#    execution_yaml["kind"] = "GenerateArtifactsTask" if migrationOS == "Linux" else "WindowsGenerateArtifactsTask"
#    # Remove flow placeholder as its only used for appx
#    execution_yaml["spec"].pop("flow")
#else:
#    execution_yaml["kind"] = "AppXGenerateArtifactsTask"
#    # set the flow name
#    execution_yaml["spec"]["flow"]["name"] = f'appx-generateartifactsflow-{migrationName}'

# Write Configured YAML
execution_manifest = "/" + execution_name + ".yaml"
with open(execution_manifest, "w") as m:
    yaml.dump(execution_yaml, m)
os.system("cat " + execution_manifest)

# Start Migration Execution
command = ['kubectl', 'apply', '-f', execution_manifest]
output = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, encoding='utf-8')

print(output.stdout)
output.check_returncode()
