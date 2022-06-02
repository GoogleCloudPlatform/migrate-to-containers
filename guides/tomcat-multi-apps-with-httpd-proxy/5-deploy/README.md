# Deploying your migrated workloads to GKE
The simplest way to build and deploy your migrated workloads is by using [Skaffold](https://skaffold.dev/). At the root folder of each migration artifacts you will find a **skaffold.yaml** file which can be used to build and deploy the migrated workloads.

## Deploy your containerized MySQL
Once the MySQL artifacts were reviewed and modified to your satisfaction, you are ready to deploy MySQL on your GKE cluster. You can do so by running the command:
``` bash
cd ~/m4a-apps/mysql
skaffold run -d gcr.io/${PROJECT_ID}
```
This command will create your apps-mysql pod and will create a service to expose it within the GKE cluster. You can check the status of the service by running the command:
``` bash
kubectl get service
```

Now that your MySQL is running in a container you can deploy your Tomcat containers

## Deploy your containerized Tomcat applications
Now that you have downloaded and reviewd your artifacts, you are almost ready to deploy your FlowCRM and Petclinic Tomcat applications on your GKE cluster. You can do so by running the commands:
``` bash
cd ~/m4a-apps/tomcat
skaffold run -d gcr.io/${PROJECT_ID}
```
This command will create your FlowCRM and Petclinic deployments with 1 pod each and will create 2 services to expose them both internally to the cluster. You can check the status of the service by running the command:
``` bash
kubectl get service
```

## Verify your containerized Tomcat applications
In order to verify that the migrated applications are running inside the containers, you can use a lightweight Busybox pod with shell to check the Tomcat applications connectivity. To start a temporary BusyBox pod you can run the below command:
``` bash
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
```
**Note:** If you don't see a command prompt, try pressing enter.

Once you have shell access you may run the below commands to verify that the Tomcat applications are running and serving HTTP requests:
``` bash
printf "GET /petclinic/ HTTP/1.1\r\nHost: z\r\n\r\n" | nc tomcat-petclinic 8080 | egrep HTTP
printf "GET /flowcrm/login HTTP/1.1\r\nHost: z\r\n\r\n" | nc tomcat-flowcrm 8080 | egrep HTTP
```

The output from both commands should be:
``` bash
HTTP/1.1 200
```

Run the `exit` command to exit the shell session and remove the BusyBox pod:
``` bash
exit

```

You are now ready to [optimize](../6-optimize/README.md) your migrated containers and expose them via an Ingress
