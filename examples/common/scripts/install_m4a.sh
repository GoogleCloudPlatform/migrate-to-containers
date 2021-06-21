#!/bin/bash

set -euo pipefail

# create service account
gcloud iam service-accounts create m4a-install --project=${PROJECT_ID}

# add permissions
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:m4a-install@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/storage.admin"

# download the key
gcloud iam service-accounts keys create m4a-install.json --iam-account=m4a-install@${PROJECT_ID}.iam.gserviceaccount.com --project=${PROJECT_ID}

# create a GKE processing cluster
gcloud container clusters create m4a-proc-cluster \
 --project ${PROJECT_ID} --zone=${ZONE_ID} --num-nodes 1 --machine-type "n1-standard-4" --image-type "UBUNTU_CONTAINERD" --enable-stackdriver-kubernetes

# connect to GKE cluster
gcloud container clusters get-credentials m4a-proc-cluster --zone ${ZONE_ID} --project ${PROJECT_ID}

# run migctl install
migctl setup install --json-key=m4a-install.json