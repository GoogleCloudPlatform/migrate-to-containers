# Migrating your VMs to containers 

**Note:** It is useful to create a workspace for managing the migrations plans and artifacts. To create such workspace in your cloud shell environment run the commands below:
``` bash
mkdir ~/m2c-petclinic
cd ~/m2c-petclinic
```

## Migrating your MySQL VM to container
Start by creating a folder for your MySQL migration artifacts:
``` bash
mkdir mysql
cd mysql
```

1. Before migrating a GCE VM using Migrate to Containers you must turn off the VM. Turn it off by running the command:  
``` bash
gcloud compute instances stop petclinic-mysql --project $PROJECT_ID --zone $ZONE_ID
```

2. Create a migration plan using 'migctl' command line interface (this should take a couple of minutes to finish):
``` bash
migctl migration create petclinic-db-migration --source my-ce-src --vm-id petclinic-mysql --type linux-system-container
```
**Note that we are using the linux-system-container type to migrate the VM and also create a persistent volume for the database data folder**

3. Check the migration plan generation using the command:
``` bash
migctl migration status petclinic-db-migration
```

**Note:** It will take several minutes for this step to complete, keep checking using the above command until you see the status changed to `Completed`.

4. Download and review the migration plan by running the command:
``` bash
migctl migration get petclinic-db-migration
```
It will create two file on your local file system called **petclinic-db-migration.yaml** and **petclinic-db-migration.data.yaml**.

5. Modify petclinic-db-migration.data.yaml to create a persistent volume for the database data folder. You do so by pasting the below into the yaml file:   
``` yaml
volumes:
- deploymentPvcName: petclinic-db-pvc
  folders:
  - /var/lib/mysql
  newPvc:
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 10G
```

6. Enable M2C enhanced runtime by running the below command:
``` bash
sed -i 's/v2kServiceManager: false/v2kServiceManager: true/g' petclinic-db-migration.yaml
```

7. To update the migration plan with the folder modification you need to upload the modified yaml files. You do so by returning to cloud shell and running the command:
``` bash
migctl migration update petclinic-db-migration --main-config petclinic-db-migration.yaml --data-config petclinic-db-migration.data.yaml
```

8. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
``` bash
migctl migration generate-artifacts petclinic-db-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can check the progress of your migration by running the command:
``` bash
migctl migration status petclinic-db-migration
```
For a more verbose output you add the flag `-v` to the command above. 

**Note:** This step takes several minutes, keep running the above command periodically until the status is `Completed`.

9. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command:
``` bash
migctl migration get-artifacts petclinic-db-migration
```
The downloaded artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate to Containers container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated MySQL container and expose it via a service. It also includes a [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and a [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reserving-a-persistentvolume) for the database data folder.
* **services-config.yaml** - The services-config.yaml file allows you to easily enable or disable services that were being used in the source VM.

10. One change that we would make to keep the service name consistent with the one expected by the Tomcat instance is to change the service name from `petclinic-mysql-mysqld` to `petclinic-mysql` in the `deployment_spec.yaml` file. First run the command:
``` bash
edit deployment_spec.yaml
```
Then find the kubernetes service named `petclinic-mysql-mysqld` and remove the trailing `-mysqld` from the name of the service. Save the file and you are now ready to deploy your MySQL container.

## Migrating your Tomcat VM to container
Start by creating a folder for your Tomcat migration artifacts:
``` bash
mkdir ~/m2c-petclinic/tomcat
cd ~/m2c-petclinic/tomcat
```
1. Before migrating a GCE VM using Migrate to Containers you must turn off the VM. Turn it off by running the command:  
``` bash
gcloud compute instances stop tomcat-petclinic --project $PROJECT_ID --zone $ZONE_ID
```

2. Create a migration plan using 'migctl' command line interface. This time you will use the `tomcat-container` type which will only migrate the Tomcat configuration and the applications deployed on it:
``` bash
migctl migration create petclinic-migration --source my-ce-src --vm-id tomcat-petclinic --type tomcat-container
```

3. Check the migration plan generation using the command:
``` bash
migctl migration status petclinic-migration
```
As with the MySQL step above, wait a few minutes until you see the command has succeeded before continuing. 

3. Download and review the migration plan by running the command:
``` bash
migctl migration get petclinic-migration
```

4. Migrate to Containers will create a file on your local file system called **petclinic-migration.yaml**. You can now open it in cloud shell editor by running the command `edit petclinic-migration.yaml`. The migration plan should look like below:
``` yaml
# If set to true, sensitive data specified in sensitiveDataPaths will be uploaded to the artifacts repository.
includeSensitiveData: false
tomcatServers:
- name: tomcat-bdfea8a2
  catalinaBase: /opt/tomcat
  catalinaHome: /opt/tomcat
  images:
  - name: tomcat-petclinic-tomcat-bdfea8a2
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/petclinic.war
    # Parent image for the generated container image.
    fromImage: tomcat:8.5-jre11-openjdk
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container’s initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: 2048M
        requests: 1280M
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
```

Since there is just a single Tomcat application that you are containerizing, we can update the migration plan to remove the unique identifier (shown as `-xxxxxxxx` above but in your file it will actuallly be a string of numbers and letters) attached to both the tomcat server and image names. Once removed, your migration plan yaml should look like below:
``` yaml
# If set to true, sensitive data specified in sensitiveDataPaths will be uploaded to the artifacts repository.
includeSensitiveData: false
tomcatServers:
- name: tomcat
  catalinaBase: /opt/tomcat
  catalinaHome: /opt/tomcat
  images:
  - name: tomcat-petclinic
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/petclinic.war
    # Parent image for the generated container image.
    fromImage: tomcat:8.5-jre11-openjdk
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container’s initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: 2048M
        requests: 1280M
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
```

5. You can now update the migration by running the command:
``` bash
migctl migration update petclinic-migration --main-config petclinic-migration.yaml
```

4. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
``` bash
migctl migration generate-artifacts petclinic-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can 

5. Check the progress of your migration by running the command:
``` bash
migctl migration status petclinic-migration
```
For a more verbose output you add the flag `-v` to the command above. 

When the above command shows the artifact creation has finished, move on to the next step.

5. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command below:
``` bash
```
migctl migration get-artifacts petclinic-migration
The artifacts will be downloaded into `tomcat/tomcat-petclinic` directory which you can access by running the command `cd tomcat/tomcat-petclinic/` and it includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image for your Tomcat applications by leveraging the community Tomcat Docker image. The default image may be changed during migration by modifying `fromImage` or by modifying the `FROM` string in the Dockerfile.
* **build.sh** - The build.sh script is used to build the container image for your Tomcat by leveraging [Cloud Build](https://cloud.google.com/build). You **MUST** set an environment variable named *PROJECT_ID* with the project id which is going to store the image and optionally supply a VERSION environment variable to give your build a specific version. Once changed, you can build your container image by running the commands
``` bash
export VERSION=latest
bash build.sh
```
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated Tomcat container and expose it via a service. **Note** that the service will be exposed via **ClusterIP** by default and you may change this to a LoadBalancer in-order to make your Tomcat application available externally. Before applying the deployment yaml you **MUST** replace *<my_project>* with the project id that was used in your `build.sh` script.
* **additionalFiles.tar.gz** - An archive containing any additional files that are needed by Tomcat and were specified in the migration plan.
* **apps/petclinic.war** - An directory containing the Petclinic application that was selected to be migrated in the migration plan.
* **tomcatServer.tar.gz** - An archive containing the original CATALINA_HOME content and it is used in the Dockerfile to override the default Tomcat settings.
* **logConfigs.tar.gz** - An archive containing log files (log4j2, log4j and logback) that were modified from logging to local filesystem to log to a console appender.
* **cloudbuild.yaml** - A sample Cloud Build yaml that can be used to continously build the application from source, build a new docker image and push it to GCR.  

**RECOMMENDED**
If you would like to expose your Tomcat via a load balancer you can modify the service definition in `deployment_spec.yaml` by adding the LoadBalancer type to the service:
<pre>
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: v1.11.1
  name: tomcat-petclinic
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  <b>type: LoadBalancer</b>
  selector:
    app: tomcat-petclinic
status:
  loadBalancer: {}
</pre>

You are now ready to [deploy](../4-deploy/README.md) your migrated containers