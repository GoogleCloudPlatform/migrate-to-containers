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

import csv
import os
import sys
from pathlib import Path
import subprocess
import time
import yaml

csvFile = sys.argv[1]
planPatchPath = sys.argv[2]
m4aPipelineTemplateFile = sys.argv[3]
image = sys.argv[4]


def verify_line(line):
    """Makes sure the line is formatted correctly, and the contents are valid"""
    # Check the OS is Supported
    if line[3] not in ["Linux"]:
        print(f"[ERROR] OS not supported: {line[3]}")
        return False

    # Check Intent is Supported
    if line[4] not in ["Image", "ImageAndData", "Data"]:
        print(f"[ERROR] Intent not supported: {line[4]}")
        return False

    # Check Intent is Supported
    if line[5] not in ["system", "tomcat", "open-liberty"]:
        print(f"[ERROR] AppType not supported: {line[5]}")
        return False

    # Check Plan Patch File
    if len(line) > 6:
        plan_patch_file = Path(planPatchPath + '/' + line[6])

        if plan_patch_file.is_file() is False:
            print(f"[ERROR] Plan Patch File doesn't exist: {plan_patch_file} ")
            return False

        if plan_patch_file.suffix not in [".yaml", ".YAML", ".yml", ".YML", ".json", ".JSON"]:
            print(f"[ERROR] Plan Patch File suffix not supported: {plan_patch_file}")
            return False

    # TODO: Add More Verifications

    # All Checks Passed
    return True


def run_migration(line):
    """Runs the Migration Pipeline for the Line"""
    # Load PipelineRun Manifest YAML Template
    with open(m4aPipelineTemplateFile) as m:
        pipelinerun_yaml = yaml.load(m, Loader=yaml.SafeLoader)

    # Configure Basic YAML Params
    pipelinerun_yaml["metadata"]["name"] = line[0]
    for param in pipelinerun_yaml["spec"]["params"]:
        if param["name"] == "migrationName":
            param["value"] = line[0]
        if param["name"] == "migrationAppType":
            param["value"] = line[5]
        if param["name"] == "migrationIntent":
            param["value"] = line[4]
        if param["name"] == "migrationOS":
            param["value"] = line[3]
        if param["name"] == "migrationSource":
            param["value"] = line[2]
        if param["name"] == "migrationVmId":
            param["value"] = line[1]
        if param["name"] == "image":
            param["value"] = image

    # Add Plan Patch Params if needed
    if len(line) > 6:
        patch_name = line[6]
        file_param = dict()
        file_param["name"] = "migrationPlanPatchFile"
        file_param["value"] = patch_name
        pipelinerun_yaml["spec"]["params"].append(file_param)

        plan_patch_cm_name = line[0] + "-plan-patch-cm"

        os.system("kubectl delete configmap " + plan_patch_cm_name)
        cm_create_cmd = ['kubectl', 'create', 'configmap', plan_patch_cm_name,
                         '--from-file=' + patch_name + '=' + planPatchPath + '/' + patch_name]
        execute_command(cm_create_cmd)

        cm_param = dict()
        cm_param["name"] = "planPatchConfigMapName"
        cm_param["value"] = plan_patch_cm_name
        pipelinerun_yaml["spec"]["params"].append(cm_param)

    # Write Configured YAML
    pipelinerun_manifest = "/" + line[0] + ".yaml"
    with open(pipelinerun_manifest, "w") as m:
        yaml.dump(pipelinerun_yaml, m)

    # Start PipelineRun
    os.system("cat " + pipelinerun_manifest)
    apply_cmd = ['kubectl', 'apply', '-f', pipelinerun_manifest]
    execute_command(apply_cmd)


def execute_command(command):
    output = subprocess.run(command, capture_output=True, encoding='utf-8')
    if len(output.stderr) > 0:
        print(output.stderr)
    output.check_returncode()
    return output


def check_migration(line):
    """Checks the status of the migration pipeline run, returns true when migration is finished"""
    pipelinerun_name = line[0]

    status_cmd = ['kubectl', 'get', 'pipelinerun', pipelinerun_name, '-o', 'jsonpath={.status.conditions[0].status}']
    status = execute_command(status_cmd).stdout

    if status == "True":
        print("Migration '", pipelinerun_name, "' Completed Successfully")
        return True
    elif status == "False":
        reason_cmd = ['kubectl', 'get', 'pipelinerun', pipelinerun_name, '-o',
                      'jsonpath={.status.conditions[0].reason}']
        reason = execute_command(reason_cmd).stdout
        print("Migration '", pipelinerun_name, "' Completed with Errors. Reason: ", reason)
        return True
    else:
        print("Migration '", pipelinerun_name, "' In Progress")
        return False


# Start
print("CSV: ", csvFile)
print("Template: ", m4aPipelineTemplateFile)

# Read CSV
with open(csvFile, 'r') as f:
    reader = csv.reader(f, delimiter=',')

    # Skip Past Headers
    next(reader, None)

    # Parce CSV Lines, and check which ones can be migrated
    migration_lines = list()
    for line in reader:
        good = verify_line(line)

        if not good:
            print("[ERROR] line failed verification: ", line)
            continue

        # TODO: Add check if already migrated
        migration_lines.append(line)

# Migrate the new/good Instances
for line in migration_lines:
    run_migration(line)

# Monitoring Migrations
print()
print("Starting Monitoring")
while True:
    migrations_left = migration_lines.copy()

    print()
    # Cycle through migrations and check if complete
    for line in migration_lines:
        done = check_migration(line)
        if done:
            migrations_left.remove(line)

    migration_lines = migrations_left

    # Exit when all migrations have completed
    if len(migration_lines) == 0:
        print("All migrations complete!")
        break

    # Delay next round of checks
    time.sleep(45)
