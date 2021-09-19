#!/usr/bin/env bash
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

yaml_inject_block () {
  srcfile=$1
  path=$2
  destyaml=$3
  BLOCK=$(cat $srcfile) \
    yq eval "$path style=\"literal\" | $path = strenv(BLOCK)" $destyaml
}

echo "Creating Pipeline Service Account"
kubectl apply -f tekton/manifests/tekton-service-account.yaml
kubectl apply -f tekton/manifests/tekton-cluster-roles.yaml
kubectl apply -f tekton/manifests/tekton-cluster-role-bindings.yaml

echo ""
echo "Creating ConfigMaps"
kubectl create configmap m4a-empty-patch-cm

TMP_YAML=m4a-migration-configmap.yaml.tmp

yaml_inject_block tekton/manifests/migration-pipelinerun.yaml '.data."migration-pipelinerun.yaml"' tekton/manifests/m4a-migration-configmap.yaml > $TMP_YAML
yaml_inject_block tekton/manifests/m4a-migration.yaml '.data."m4a-migration.yaml"' $TMP_YAML > $TMP_YAML.1
yaml_inject_block tekton/manifests/m4a-generateartifacts.yaml '.data."m4a-generateartifacts.yaml"' $TMP_YAML.1 > $TMP_YAML.2

kubectl apply -f $TMP_YAML.2
rm $TMP_YAML*

echo ""
echo "Creating Tasks"
kubectl apply -f tekton/manifests/git-clone.yaml

TMP_YAML=m4a-migration-task.yaml.tmp

yaml_inject_block tekton/scripts/create-migration.py .spec.steps[0].script tekton/manifests/m4a-migration-task.yaml > $TMP_YAML
yaml_inject_block tekton/scripts/wait-for-migration.py .spec.steps[1].script $TMP_YAML > $TMP_YAML.1
yaml_inject_block tekton/scripts/customize-migration-plan.py .spec.steps[2].script $TMP_YAML.1 > $TMP_YAML.2
yaml_inject_block tekton/scripts/execute-migration.py .spec.steps[3].script $TMP_YAML.2 > $TMP_YAML.3
yaml_inject_block tekton/scripts/wait-for-migration.py .spec.steps[4].script $TMP_YAML.3 > $TMP_YAML.4

kubectl apply -f $TMP_YAML.4
rm $TMP_YAML*

yaml_inject_block tekton/scripts/migration-orchestration.py .spec.steps[0].script tekton/manifests/m4a-orchestration-task.yaml \
    | kubectl apply -f -

echo ""
echo "Creating Pipelines"
kubectl apply -f tekton/manifests/m4a-migration-pipeline.yaml
kubectl apply -f tekton/manifests/m4a-orchestration-pipeline.yaml
