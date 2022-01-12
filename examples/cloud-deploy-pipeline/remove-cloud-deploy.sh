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

echo "Please provide your cluster project id:"

read PROJECT_ID

echo "Please provide the region you provided when creating the pipeline:"

read REGION

PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
SA=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com

echo "Please provide the previously used migration name: "
read MIGRATION_NAME

tmpdir=$(mktemp -d)

pushd $tmpdir

gcloud source repos clone $MIGRATION_NAME --project $PROJECT_ID || true
pushd $MIGRATION_NAME
git checkout origin/main
popd
gcloud beta deploy delete --file $MIGRATION_NAME/clouddeploy.yaml --region=${REGION} --project=${PROJECT_ID} --force || true
gcloud beta builds triggers delete "${MIGRATION_NAME}-trigger" --project $PROJECT_ID || true
gcloud source repos delete $MIGRATION_NAME --project $PROJECT_ID || true


read -r -p "Do you want to remove roles/clouddeploy.jobRunner,roles/container.developer from $SA (required for cloud deploy to work in your project using the compute default service account)? [Y/n]: " response
response=${response,,} # to lower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  gcloud -q projects remove-iam-policy-binding $PROJECT_ID \
    --condition=None --member=serviceAccount:$SA --role="roles/clouddeploy.jobRunner"
  
  gcloud -q projects remove-iam-policy-binding $PROJECT_ID \
    --condition=None --member=serviceAccount:$SA --role="roles/container.developer"
fi

CLOUDBUILD_SA=${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com

read -r -p "Do you want to remove roles/iam.serviceAccountUser on $SA from $CLOUDBUILD_SA (required for cloud build to start cloud deploy release)? [Y/n]: " response
response=${response,,} # to lower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  gcloud -q iam service-accounts remove-iam-policy-binding $SA \
    --member=serviceAccount:$CLOUDBUILD_SA \
    --role=roles/iam.serviceAccountUser \
    --project=$PROJECT_ID
fi

services=(clouddeploy.googleapis.com cloudbuild.googleapis.com sourcerepo.googleapis.com)

echo "The following APIs can be disabled if no longer needed"
for service in "${services[@]}"; do
  echo "$service"
done

read -r -p "Do you want to disable those services? (please note there might be a cost associated with this) [Y/n]: " response
response=${response,,} # to lower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  for service in "${services[@]}"; do
    gcloud services disable $service --project $PROJECT_ID --force
  done
fi

popd
