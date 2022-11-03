#!/bin/bash
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

set -euo pipefail

# create service account
gcloud iam service-accounts create m2c-install --project=${PROJECT_ID}

# add permissions
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:m2c-install@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/storage.admin"

# download the key
gcloud iam service-accounts keys create m2c-install.json --iam-account=m2c-install@${PROJECT_ID}.iam.gserviceaccount.com --project=${PROJECT_ID}

# create a GKE processing cluster
gcloud container clusters create m2c-proc-cluster \
 --project ${PROJECT_ID} --zone=${ZONE_ID} --num-nodes 1 --machine-type "n1-standard-4" --image-type "ubuntu_containerd"

# connect to GKE cluster
gcloud container clusters get-credentials m2c-proc-cluster --zone ${ZONE_ID} --project ${PROJECT_ID}

# run migctl install
migctl setup install --json-key=m2c-install.json
