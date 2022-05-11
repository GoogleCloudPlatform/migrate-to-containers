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

    # Check appType is Supported
    if line[3] not in ["linux-system-container", "tomcat-container", "windows-iis-container", "websphere-container"]:
        print(f"[ERROR] AppType not supported: {line[3]}")
        return False

    # Check Data Config
    if len(line) > 4:
        if line[4] != "":
            data_config_file = Path(planPatchPath + '/' + line[4])

            if data_config_file.is_file() is False:
                print(f"[ERROR] Data Config File doesn't exist: {data_config_file} ")
                return False

            if data_config_file.suffix not in [".yaml", ".YAML", ".yml", ".YML"]:
                print(f"[ERROR] Data Config File suffix not supported: {data_config_file}")
                return False

    # Check Plan Patch File
    if len(line) > 5:
        plan_patch_file = Path(planPatchPath + '/' + line[5])

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
            param["value"] = line[3]
        if param["name"] == "migrationSource":
            param["value"] = line[2]
        if param["name"] == "migrationVmId":
            param["value"] = line[1]
        if param["name"] == "image":
            param["value"] = image

    # Add Data Config Params if needed
    if len(line) > 4:
        plan_patch_cm_name = line[0] + "-plan-patch-cm"

        os.system("kubectl delete configmap " + plan_patch_cm_name)

        cm_create_cmd = ['kubectl', 'create', 'configmap', plan_patch_cm_name]

        cm_param = dict()
        cm_param["name"] = "planPatchConfigMapName"
        cm_param["value"] = plan_patch_cm_name
        pipelinerun_yaml["spec"]["params"].append(cm_param)

        if line[4] != "":
            data_config_name = line[4]
            file_param = dict()
            file_param["name"] = "migrationDataConfigFile"
            file_param["value"] = data_config_name
            pipelinerun_yaml["spec"]["params"].append(file_param)

            cm_create_cmd.append('--from-file=' + data_config_name + '=' + planPatchPath + '/' + data_config_name)
        # Add Plan Patch Params if needed
        if len(line) > 5:
            if line[5] != "":
                patch_name = line[5]
                file_param = dict()
                file_param["name"] = "migrationPlanPatchFile"
                file_param["value"] = patch_name
                pipelinerun_yaml["spec"]["params"].append(file_param)

#                plan_patch_cm_name = line[0] + "-plan-patch-cm"

#                os.system("kubectl delete configmap " + plan_patch_cm_name)
#                cm_create_cmd = ['kubectl', 'create', 'configmap', plan_patch_cm_name,
#                                '--from-file=' + patch_name + '=' + planPatchPath + '/' + patch_name]
                cm_create_cmd.append('--from-file=' + patch_name + '=' + planPatchPath + '/' + patch_name)

#                cm_param = dict()
#                cm_param["name"] = "planPatchConfigMapName"
#                cm_param["value"] = plan_patch_cm_name
#                pipelinerun_yaml["spec"]["params"].append(cm_param)
        execute_command(cm_create_cmd)
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
