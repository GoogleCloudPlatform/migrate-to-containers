# Setup cloud deploy pipeline for M2C migrated workload

In this example, you will start from a succefully migrated workload of M2C and create a deployment pipeline using cloud deploy of that migrated workload into your cluster.
You will run a script that will setup the following parts in a project of your choice:  
1. Cloud Source Repository (git repository hosted on gcp)
1. Cloud Build Trigger (will trigger automatically on pushed to master)
1. Cloud Deploy Pipeline (will let you managed approvals for deployments and promotion from dev to production clusters)
1. All required IAM bindings to make it work

## Setup
### Prerequisites

1. Clone this repository and cd into this tutorial folder
```bash
git clone https://github.com/GoogleCloudPlatform/migrate-to-containers
cd migrate-to-containers/examples/cloud-deploy-pipeline
```
2. Ensure gcloud is correctly configured
```bash
gcloud init && git config --global credential.https://source.developers.google.com.helper gcloud.
```
3. Download your migration artifacts
```bash
migctl migration get-artifacts <migration name>
```

### Running the script

After entering the directory and downloading the artifacts run the following commands:
```bash
./setup-cloud-deploy.sh
cd <repo name>/
git add .
git commit -m "Initial commit"
git push
```

This script will ask you for the following information in order to succefully complete:
1. Your cloud project name
1. Your cluster name and region/zone
1. If you want to enable the relevant services: cloudbuild, clouddeploy and sourcerepo)
1. If you want to set up the relevant permissions.
1. If you want to set up cloud deploy.
1. If you want to set up cloud source repository.

## Removal

For convenience we have provided the script `./remove-cloud-deploy.sh` which will help you remove the components created in the setup script above.
The script will ask for approval for each of the things it will want to remove.
