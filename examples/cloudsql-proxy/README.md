# Connecting to Cloud SQL instance from a migrated workload using the Cloud SQL Auth Proxy 

Oftentimes when migrating legacy workloads using Migrate for Anthos and GKE they consume SQL database services which are normally migrated to [Cloud SQL](https://cloud.google.com/sql). Cloud SQL is a fully managed relational database service for MySQL, PostgreSQL and SQLServer.

Connecting from an application running on GKE to a Cloud SQL instance, you can use either the [Cloud SQL Auth Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy) or connect directly via private IP address. The recommended way of doing so is via the Cloud SQL Auth Proxy because it provides strong encryption and authentication using IAM, which can help keep your database more secure.

Configuring a migrated legacy workload to connect to Cloud SQL using the Cloud SQL Auth Proxy has limitations which prevents you fom running the Cloud SQL Auth Proxy as a sidecar and you therefore must run it as a standalone service. Note that in this example we are using port 3306 to connect to the database which is the default port for MySQL, however, you should modify the port to match your relevant database (PostgreSQL or SQLServer)
## What you'll do

In this example you’ll do the following:

* Prepare your Google Cloud environment
* Create a GKE cluster
* Create a MySQL CloudSQL instance
* Create a service account to connect from the Cloud SQL Auth Proxy to the MySQL Cloud SQL instance
* Deploy Cloud SQL Auth Proxy into a GKE cluster
* Expose the Cloud SQL Auth Proxy as a Kubernetes Service
* Verify connection from the Cloud SQL Auth Proxy to the Cloud SQL instance
* Use the Cloud SQL Auth Proxy service to connect from your migrated workload
* Clean up by deleting the project

## Before you begin

For this reference guide, you need a Google Cloud project. You can create a new one, or select a project you already created:

1. Select or create a Google Cloud project.  
[GO TO THE PROJECT SELECTOR PAGE](https://console.cloud.google.com/cloud-resource-manager)

2. Enable billing for your project.  
[ENABLE BILLING](https://support.google.com/cloud/answer/6293499#enable-billing)

3. Enable the Service Management API, Service Control API, Cloud Resource Manager API, Compute Engine API, Kubernetes Engine API, Google Container Registry API, Cloud Build API.  
[ENABLE THE APIS](https://console.cloud.google.com/flows/enableapi?apiid=servicemanagement.googleapis.com%20servicecontrol.googleapis.com%20cloudresourcemanager.googleapis.com%20compute.googleapis.com%20container.googleapis.com%20containerregistry.googleapis.com%20cloudbuild.googleapis.com%20sqladmin)

4. [![Open Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell?shellonly=true)

5. Set environment variables to have your GCP project id, region and zone 
``` shell
export PROJECT_ID=your_project_id
export REGION_ID=your_region
export ZONE_ID=your_zone
```

## Create a GKE cluster
The GKE cluster is used to run your migrated workload and the Cloud SQL Auth Proxy. To create a GKE cluster run the command below:
``` shell
gcloud container clusters create my-cluster \
 --project ${PROJECT_ID} --zone=${ZONE_ID} --num-nodes 1 --machine-type "n1-standard-4" --enable-stackdriver-kubernetes
```

You should now connect to your GKE cluster by running the command:
``` shell
gcloud container clusters get-credentials my-cluster --zone ${ZONE_ID} --project ${PROJECT_ID}
```

## Create a MySQL CloudSQL instance
You can create a MySQL Cloud SQL instance using gcloud by running the command:
``` shell
gcloud sql instances create myinstance \
--database-version=MYSQL_8_0 \
--cpu=1 \
--memory=3840MB \
--region=$REGION_ID
```

## Create a service account to connect from the Cloud SQL Auth Proxy to the MySQL Cloud SQL instance
You can create the service account by running the command:
``` shell
gcloud iam service-accounts create my-sql-svc-account --display-name="My Cloud SQL Service Account"
```
To view the service account details you can run the following command:
``` shell
gcloud iam service-accounts describe my-sql-svc-account@${PROJECT_ID}.iam.gserviceaccount.com
```

### Grant the service account with the required permissions
The service account requires the Cloud SQL Client role to be able to connect to the instance. See the command below:
``` shell
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:my-sql-svc-account@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudsql.client
```
If you require additional permissions you may add the Cloud SQL Admin or Cloud SQL Editor roles as needed. See [Creating a service account](https://cloud.google.com/sql/docs/mysql/connect-admin-proxy#create-service-account) for more information.

### Create a credential file for your service account key
``` shell
gcloud iam service-accounts keys create my-sql-sa-key.json \
--iam-account=my-sql-svc-account@${PROJECT_ID}.iam.gserviceaccount.com
```

### Create a Kubernetes Secret with the service account key
``` shell
kubectl create secret generic my-cloud-sql-secret \
--from-file=service_account.json=my-sql-sa-key.json
```

## Deploy Cloud SQL Auth Proxy into a GKE cluster
The [cloudsql_deployment.yaml](./cloudsql_deployment.yaml) is a Kubernetes Deployment yaml which deploys the Cloud SQL Auth Proxy into a Kubernetes cluster. In order to use it, you must replace the connection name with the one for your Cloud SQL instance. You can do so by running the command below to store your DB connection string in an environment variable:
``` shell
export DB_CONN=$(gcloud sql instances describe myinstance | grep connectionName | cut -c 17-)
```

You then configure the connection name in [`cloudsql_deployment.yaml`](./cloudsql_deployment.yaml#L21)
``` yaml
- name: sql-proxy
  image: gcr.io/cloudsql-docker/gce-proxy:1.22.0
  command: ["/cloud_sql_proxy",
            "-instances=<CHANGE_DB_CONNECTION>=tcp:0.0.0.0:3306",
            "-credential_file=/secrets/cloudsql/service_account.json"]
```
First, make a copy of this yaml file in your cloudshell terminal and then update the connection string by running the command below:
``` shell
sed -i "s/CHANGE_DB_CONNECTION/${DB_CONN}/g" cloud-sql-deployment.yaml
```

You are now ready to deploy your Cloud SQL Auth Proxy to your GKE cluster. You deploy it by running the command:
``` shell
kubectl apply -f cloudsql_deployment.yaml
```

## Expose the Cloud SQL Auth Proxy as a Kubernetes Service and make it available for your application
In order to connect your migrated workload to the Cloud SQL Auth Proxy you need to expose it as a Kubernetes service. 
``` yaml
kind: Service
apiVersion: v1
metadata:
  name: sql-proxy-service
spec:
  selector:
    app: sql-proxy
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
```
You can do so by applying the yaml file [`cloudsql_service.yaml`](./cloudsql_service.yaml) on your GKE cluster:
``` shell
kubectl apply -f cloudsql_service.yaml
```

## Verify Cloud SQL connectivity
To find the pod that was just created you should ru the command:
``` shell
kubectl get pods
```
Then you can check the logs by running the command:
``` shell
kubectl logs sql-proxy-deployment-xxx-yyy
```
And you should see the last line in the log showing
``` shell
2021/08/02 13:51:53 Ready for new connections
```

## Use the Cloud SQL Auth Proxy service to connect from your migrated workload
You can find the Cloud SQL Auth Proxy service name by running the command:
``` shell
kubectl get svc
```
The service name is **sql-proxy-service** and this is the name you should use in your application connection string.

### Configure your application
You are now ready to configure your application to connect to your Cloud SQL Auth Proxy by setting your DB hostname to **sql-proxy-service**

## Cleaning up
The simplest way to avoid any unexpected billing charges is to delete your GCP project. You can do so by running the command below in cloud shell:
``` shell
gcloud projects delete $PROJECT_ID
```