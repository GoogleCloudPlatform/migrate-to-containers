#!/bin/bash -e
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

read -r -p "Name for the repo, pipeline and triggers: " MIGRATION_NAME

IMAGE_NAME=$(grep 'image:' deployment_spec.yaml | sed 's/\s*image: //' | sed 's/\:[0-9a-z\-]*//')

# IMAGE_PROJECT=$(echo $IMAGE_NAME | sed -E 's/.*\gcr\.io\/([^/]+)\/.*/\1/')

echo "Detected image with name $IMAGE_NAME in the deployment_spec"

echo "Please provide your cluster project id:"

read PROJECT_ID

PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
SA=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com

services=(cloudbuild.googleapis.com clouddeploy.googleapis.com sourcerepo.googleapis.com)

echo "The following APIs needs to be enabled in order to setup the deployment pipeline"
for service in "${services[@]}"; do
  echo "$service"
done

read -r -p "Do you want to enable those services? (please note there might be a cost associated with this) [Y/n]: " response
response=${response,,} # to lower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  for service in "${services[@]}"; do
    gcloud services enable $service --project $PROJECT_ID
  done
else
  exit 1
fi

read -r -p "Do you want to give $SA roles/clouddeploy.jobRunner,roles/container.developer (required for cloud deploy to work in your project using the compute default service account)? [Y/n]: " response
response=${response,,} # to lower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  gcloud -q projects add-iam-policy-binding $PROJECT_ID \
    --condition=None --member=serviceAccount:$SA --role="roles/clouddeploy.jobRunner"
  
  gcloud -q projects add-iam-policy-binding $PROJECT_ID \
    --condition=None --member=serviceAccount:$SA --role="roles/container.developer"
fi

CLOUDBUILD_SA=${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com

read -r -p "Do you want to give $CLOUDBUILD_SA roles/iam.serviceAccountUser on $SA (required for cloud build to start cloud deploy release)? [Y/n]: " response
response=${response,,} # to lower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  gcloud -q iam service-accounts add-iam-policy-binding $SA \
    --member=serviceAccount:$CLOUDBUILD_SA \
    --role=roles/iam.serviceAccountUser \
    --project=$PROJECT_ID
fi

echo "Please provide your dev cluster location (zone or region):"
read LOCATION

REGION="${LOCATION%*-[a-z]}"

echo "Please provide your dev cluster name:"
read CLUSTER_NAME

read -r -p "Do you want to create cloud source repository that triggers deployment to the cluster on commits? [Y/n]: " cloudsource_resp
cloudsource_resp=${cloudsource_resp,,} # to lower
if [[ $cloudsource_resp =~ ^(yes|y| ) ]] || [[ -z $cloudsource_resp ]]; then
  gcloud source repos create $MIGRATION_NAME --project $PROJECT_ID
  gcloud source repos clone $MIGRATION_NAME --project $PROJECT_ID
  gcloud beta builds triggers create cloud-source-repositories --project $PROJECT_ID --name="${MIGRATION_NAME}-trigger" \
    --repo=$MIGRATION_NAME \
    --branch-pattern=main \
    --build-config=cloudbuild.yaml
else
  mkdir $MIGRATION_NAME
fi

echo "Creating folder '$MIGRATION_NAME' for cloud deploy pipeline:"

# copy artifacts into the pipeline folder
cp Dockerfile *.yaml $MIGRATION_NAME/
sed -E 's/image\:(.*)\:[a-z0-9\-]+/image: \1/' deployment_spec.yaml > $MIGRATION_NAME/deployment_spec.yaml

pushd $MIGRATION_NAME


cat <<SKAFFOLD > skaffold.yaml
apiVersion: skaffold/v2beta16
kind: Config
build:
  tagPolicy:
    dateTime:
      format: "2006-01-02_15-04-05.999_MST"
      timezone: "Local"
  artifacts:
  - image: ${IMAGE_NAME}
  local: {}
deploy:
  kubectl:
    manifests:
    - deployment_*
SKAFFOLD

PIPELINE_NAME=${MIGRATION_NAME}-delivery

cat <<EOF > clouddeploy.yaml
apiVersion: deploy.cloud.google.com/v1beta1
kind: DeliveryPipeline
metadata:
 name: ${PIPELINE_NAME}
description: main application pipeline
serialPipeline:
 stages:
 - targetId: dev
   profiles: []
---

apiVersion: deploy.cloud.google.com/v1beta1
kind: Target
metadata:
 name: dev
description: development cluster
gke:
 cluster: projects/${PROJECT_ID}/locations/${LOCATION}/clusters/${CLUSTER_NAME}
EOF

cat <<EOF > cloudbuild.yaml
steps:
  - name: gcr.io/k8s-skaffold/skaffold
    args:
      - skaffold
      - build
      - '--interactive=false'
      - '--file-output=/workspace/artifacts.json'
  - name: gcr.io/google.com/cloudsdktool/cloud-sdk
    entrypoint: gcloud
    args:
      [
        "beta", "deploy", "releases", "create", "rel-\${SHORT_SHA}",
        "--delivery-pipeline", "${PIPELINE_NAME}",
        "--region", "${REGION}",
        "--annotations", "commitId=\${REVISION_ID}",
        "--build-artifacts", "/workspace/artifacts.json"
      ]
EOF

read -r -p "Do you want to register the pipeline? [Y/n]: " response
response=${response,,} # to lower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  # need to see what we do if the cluster is not regional
  gcloud beta deploy apply --file clouddeploy.yaml --region=${REGION} --project=${PROJECT_ID}
fi



popd
 
