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

import copy
import jsonpatch
import os
import subprocess
import sys
import yaml

migrationName = sys.argv[1]
migrationTemplateFile = sys.argv[2]
migrationDataConfigFile = sys.argv[3]
migrationAppType = sys.argv[4]

class literal(str):
    pass

def literal_presenter(dumper, data):
    return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
yaml.add_representer(literal, literal_presenter)

def dict_deep_merge(target, customization):
    """Merges customizations into a dictionary in place"""
    for key, value in customization.items():
        if isinstance(value, list):
            if key not in target:
                target[key] = copy.deepcopy(value)
            else:
                target[key].extend(value)
        elif isinstance(value, dict):
            if key not in target:
                target[key] = copy.deepcopy(value)
            else:
                dict_deep_merge(target[key], value)
        elif isinstance(value, set):
            if key not in target:
                target[key] = value.copy()
            else:
                target[key].update(value.copy())
        else:
            target[key] = copy.copy(value)


def execute_command(command):
    """Executes a command, capturing the output"""
    output = subprocess.run(command, capture_output=True, encoding='utf-8')
    if len(output.stderr) > 0:
        print(output.stderr)
    output.check_returncode()
    return output


# Get generated plan only supports appx plugins
plan_get_cmd = ['kubectl', 'get', 'appxgenerateartifactsflows.anthos-migrate.cloud.google.com', '-n', 'v2k-system',
            f'appx-generateartifactsflow-{migrationName}', '-o', 'jsonpath={.spec.appXGenerateArtifactsConfig}']

plan_output = execute_command(plan_get_cmd)
full_plan_yaml = yaml.load(plan_output.stdout, Loader=yaml.SafeLoader)

plan_yaml = full_plan_yaml
print(f"Plan yaml: {yaml.dump(plan_yaml)}")

# Customize Plan
if migrationTemplateFile.endswith(".yaml") or \
        migrationTemplateFile.endswith(".YAML") or \
        migrationTemplateFile.endswith(".yml") or \
        migrationTemplateFile.endswith(".YML"):
    with open(migrationTemplateFile) as m:
        customization_yaml = yaml.load(m, Loader=yaml.SafeLoader)

    dict_deep_merge(plan_yaml, customization_yaml)
elif migrationTemplateFile.endswith(".json") or \
        migrationTemplateFile.endswith(".JSON"):
    with open(migrationTemplateFile) as m:
        patch = jsonpatch.json.dumps(jsonpatch.json.load(m))

    jsonpatch.apply_patch(plan_yaml, patch, in_place=True)
else:
    print("Using Default Plan")

# Change Names to match
#if migrationAppType == "system":
#    name_patch = jsonpatch.JsonPatch([
#        {'op': 'replace', 'path': '/spec/image/base', 'value': f'{migrationName}-non-runnable-base'},
#        {'op': 'replace', 'path': '/spec/image/name', 'value': migrationName},
#        {'op': 'replace', 'path': '/spec/deployment/appName', 'value': migrationName},
#    ])
#    name_patch.apply(plan_yaml, in_place=True)
#elif migrationAppType == "tomcat-container":
#    name_patch = jsonpatch.JsonPatch([
#        #{'op': 'replace', 'path': '/tomcatServers/0/imageName', 'value': f'{migrationName}-tomcat'},
#        {'op': 'replace', 'path': '/tomcatServers/0/name', 'value': migrationName},
#    ])
#    name_patch.apply(plan_yaml, in_place=True)

# Apply customized plan
#if migrationAppType != "system":
# handle appx update
appx_generateartifactsflow_get_cmd = ['kubectl', 'get', 'appxgenerateartifactsflows.anthos-migrate.cloud.google.com', '-n', 'v2k-system',
                f'appx-generateartifactsflow-{migrationName}', '-o', 'yaml']
appx_plan_output = execute_command(appx_generateartifactsflow_get_cmd)
full_appx_plan_yaml = yaml.load(appx_plan_output.stdout, Loader=yaml.SafeLoader)
full_appx_plan_yaml["spec"]["appXGenerateArtifactsConfig"] = yaml.dump(plan_yaml)

if migrationDataConfigFile.endswith(".yaml") or \
        migrationDataConfigFile.endswith(".YAML") or \
        migrationDataConfigFile.endswith(".yml") or \
        migrationDataConfigFile.endswith(".YML"):
    with open(migrationDataConfigFile) as m:
        data_config_yaml = yaml.load(m, Loader=yaml.SafeLoader)

        for i in range(len(data_config_yaml["volumes"])):
            print(data_config_yaml["volumes"][i])
            data_config_yaml["volumes"][i]["deploymentPvcName"] = migrationName + "-" + data_config_yaml["volumes"][i]["deploymentPvcName"]
        full_appx_plan_yaml["spec"]["dataConfig"] = data_config_yaml

plan_yaml = full_appx_plan_yaml
print(f'{yaml.dump(plan_yaml)}')

plan_yaml_path = "/plan.yaml"
with open(plan_yaml_path, "w") as m:
    yaml.dump(plan_yaml, m)

plan_apply_cmd = ['kubectl', 'apply', '-f', plan_yaml_path]
os.system("cat " + plan_yaml_path)
execute_command(plan_apply_cmd)
