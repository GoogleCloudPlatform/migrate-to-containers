# Deploying your migrated workloads to GKE
Prior to deploying your migrated workloads, make sure that you are in your workspace folder by running the command:
```
cd ~/m4a-petclinic
```

## Deploy your containerized MySQL
Once the MySQL artifacts were reviewed and modified to your satisfaction, you are ready to deploy Petclinic MySQL on your GKE cluster. You can do so by running the command:
```
kubectl apply -f mysql/deployment_spec.yaml
```
This command will create your petclinic-postgres pod and will create a service to expose it within the GKE cluster. You can check the status of the service by running the command:
```
kubectl get service
```

Now that your MySQL is running in a container you can deploy your Tomcat container

## Deploy your cointainerised Tomcat
Now that you have downloaded and reviewd your artifacts, you are almost ready to deploy your Petclinic Tomcat on your GKE cluster. The deployment_spec.yaml includes two environment variables, PROJECT_ID and VERSION which should be changed prior to applying the yaml. You can update and deploy by running the command:
```
sed -e "s/\${PROJECT_ID}/${PROJECT_ID}/g" -e "s/\${VERSION}/${VERSION}/g" tomcat/tomcat-petclinic/deployment_spec.yaml | kubectl apply -f -
```
This command will create your Petclinic deployment with 1 pod and will create a service to expose it. If you've modified your service to use a load balancer instead of cluster IP then it may take a couple of minutes until your external IP address is provisioned. You can check the status of the service by running the command:
```
kubectl get service tomcat-petclinic
```
To verify that your application is running and can connect to the database you can open the url `http://<external-ip>:8080/petclinic/` in your browser and try to find pet owners.
