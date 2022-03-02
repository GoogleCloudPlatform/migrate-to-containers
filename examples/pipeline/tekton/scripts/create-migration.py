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
migrationVmId = sys.argv[3]
migrationSource = sys.argv[4]
migrationOS = sys.argv[5]
migrationIntent = sys.argv[6]
migrationAppType = sys.argv[7]

# Load Migration Manifest YAML Template
with open(templateYAMLPath) as m:
    migration_yaml = yaml.load(m, Loader=yaml.SafeLoader)

# Configure YAML
migration_yaml["metadata"]["name"] = migrationName
migration_yaml["metadata"]["annotations"]["anthos-migrate.cloud.google.com/initial-intent"] = migrationIntent
migration_yaml["spec"]["appType"] = migrationAppType
migration_yaml["spec"]["osType"] = migrationOS
migration_yaml["spec"]["sourceSnapshot"]["sourceProvider"] = migrationSource
migration_yaml["spec"]["sourceSnapshot"]["sourceId"] = migrationVmId

# Write Configured YAML
migration_manifest = "/" + migrationName + ".yaml"
with open(migration_manifest, "w") as m:
    yaml.dump(migration_yaml, m)
os.system("cat " + migration_manifest)

# Start Migration Create
command = ['kubectl', 'apply', '-f', migration_manifest]
output = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, encoding='utf-8')

print(output.stdout)
output.check_returncode()
