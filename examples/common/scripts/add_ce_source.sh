#!/bin/bash
set -euo pipefail

# create service account for GCE source
gcloud iam service-accounts create m4a-ce-src --project=${PROJECT_ID}

# add required permissions
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:m4a-ce-src@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/compute.viewer"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:m4a-ce-src@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/compute.storageAdmin"

# Download service account key
gcloud iam service-accounts keys create m4a-ce-src.json --iam-account=m4a-ce-src@${PROJECT_ID}.iam.gserviceaccount.com --project=${PROJECT_ID}

# create a source for migration
migctl source create ce my-ce-src --project ${PROJECT_ID} --json-key=m4a-ce-src.json
