# Deploying your migrated workloads to GKE
The simplest way to build and deploy your migrated workloads is by using [Skaffold](https://skaffold.dev/). At the root folder of each migration artifacts you will find a **skaffold.yaml** file which can be used to build and deploy the migrated workloads.

## Deploy your containerized MySQL
Once the MySQL artifacts were reviewed and modified to your satisfaction, you are ready to build and deploy Petclinic MySQL on your GKE cluster. You can do so by running the commands:
``` bash
cd ~/m2c-petclinic/mysql
skaffold run -d gcr.io/${PROJECT_ID}
```
This command will build the container image, push it to the artifacts registry, create your petclinic-mysql pod and will create a service to expose it within the GKE cluster. You can check the status of the service by running the command:
``` bash
kubectl get service
```

Now that your MySQL is running in a container you can deploy your Tomcat container

## Deploy your containerized Tomcat
Now that you have downloaded and reviewd your artifacts, you are ready to deploy your Petclinic Tomcat on your GKE cluster. You can do so by running the commands:
``` bash
cd ~/m2c-petclinic/tomcat
skaffold run -d gcr.io/${PROJECT_ID}
```
This command will build the container image, push it to the artifacts registry, create your Petclinic deployment with 1 pod and will create a service to expose it. If you've modified your service to use a load balancer instead of cluster IP then it may take a couple of minutes until your external IP address is provisioned. You can check the status of the service by running the command:
```
kubectl get service tomcat-petclinic
```
To verify that your application is running and can connect to the database you can open the url `http://<external-ip>:8080/petclinic/` in your browser and try to find pet owners.
