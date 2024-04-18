# Migrating your VMs to containers 
## Prepare your GKE environment
Migrating the database will consist of 2 parts. The first would be the migrate the data folder into a persistent volume and the second will be migrating the database runtime into a StatefulSet.

In-order to migrate the data, you will need to connect to the GKE cluster that will be running the application. You can create the cluster and connect to it by following these steps:
1. Enable the API and create the cluster by running the commands:
``` bash
# Follow the instruction on your terminal to complete the authentication after running the command below
gcloud auth login

# Enable the API
gcloud services enable container.googleapis.com
```

You can now create the cluster by running the following gcloud command:
``` bash
# Set environment variables to have your GCP project id and zone
export PROJECT_ID=your_project_id
export ZONE_ID=your_zone

gcloud container clusters create m2c-guide --release-channel stable --zone $ZONE_ID --node-locations $ZONE_ID --enable-dataplane-v2
```

2. Install Kubectl, [Skaffold](https://skaffold.dev/) and the `gke-gcloud-auth-plugin` in order to authenticate and interact with the Kubernetes cluster that you've just created by running the script [install_container_tools.sh](../../../scripts/install_container_tools.sh):
```bash
./install_container_tools.sh
```

3. Connect to your GKE cluster
```bash
gcloud container clusters get-credentials m2c-guide --zone=$ZONE_ID --project=$PROJECT_ID
```

## Prepare your m2c cli workspace
Firstly, you'll need to ssh into the `m2c-cli` VM by using the command:
``` bash
gcloud compute ssh m2c-cli --project $PROJECT_ID --zone $ZONE_ID
```

Install Docker on the `m2c-cli` VM which is needed during the migration:
```bash
# Download the convenience script
curl -fsSL https://get.docker.com -o install-docker.sh

# Execute to install
sudo sh install-docker.sh

# Allow non root user to access Docker
sudo usermod -aG docker $USER

# Activate the group changes
newgrp docker
```

**Note:** It is useful to create a workspace for managing the migrations plans and artifacts. To create such workspace in your cloud shell environment run the commands below:
``` bash
mkdir ~/m2c-petclinic
cd ~/m2c-petclinic
```

In order to speed up copying the source VMs file systems, you can create a filters file to exclude certain folders from being copied from the source VMs file system. The exclude filters are configured in rsync format and you can use the command below to create a sample filters.txt file:
``` bash
cat > ~/filters.txt << EOF
- /proc/*
- /boot/*
- /sys/*
- /dev/*
- /home/*
- /snap/*
- /var/cache/*
- /var/backups/*
EOF
```

## Migrating your MySQL VM to container
Start by creating a folder for your MySQL migration artifacts:
``` bash
mkdir mysql
cd mysql
```

1. The first step of the migration is to copy the source VM filesystem by running the `m2c copy` command:
```bash
m2c copy gcloud -p $PROJECT_ID -z $ZONE_ID -n petclinic-mysql -o petclinic-mysql-fs --filters ~/filters.txt
```
**Protip: Add -v to m2c commands for extra info**

2. Analyze the source VM filesystem and generate a migration plan by running the `m2c analyze` command:
``` bash
m2c analyze -s petclinic-mysql-fs -p linux-vm-container -o ./migration
```
**Note that you are using the linux-vm-container type to migrate the VM and also create a persistent volume for the database data folder**

3. Review the migration plan by running the command:
``` bash
cat migration/config.yaml
```

4. Change the migration name from `linux-system` to `petclinic-mysql` by running the command:
```bash
sed -i 's/linux-system/petclinic-mysql/g' migration/config.yaml
```

5. Add an Endpoint in the `config.yaml` to expose the MySQL port(3306) as a Kubernetes service by running the command:
``` yaml
cat >> ./migration/config.yaml << EOF
  endpoints:
  - name: petclinic-mysql
    port: 3306
    protocol: TCP
EOF
```

5. Create a `dataConfig.yaml` file to create a persistent volume for the DB data folder by running the command:
``` yaml
cat > ./migration/dataConfig.yaml << EOF
volumes:
- deploymentPvcName: petclinic-mysql-db-pvc
  folders:
  - /var/lib/mysql
  newPvc:
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 10G
EOF
```

6. Migrate the data into a persistent volume by running the command:
```bash
m2c migrate-data -i migration -n default
```

7. Execute the runtime migration and generate artifacts by running the command `m2c generate`:
```bash
m2c generate -i ./migration -o ./artifacts
```

8. View the generated artifacts by running the command:
```bash
ls artifacts
```

The artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate to Containers container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated MySQL container and expose it via a service. It also includes a [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and a [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reserving-a-persistentvolume) for the database data folder.
* **services-config.yaml** - The services-config.yaml file allows you to easily enable or disable services that were being used in the source VM.
* **skaffold.yaml** - skaffold.yaml is a configuration file that describes how to build, deploy, and test an application on Kubernetes. By using [Skaffold](https://skaffold.dev/), you can build, deploy and test your containers in a similar way across all your environments.

## Migrating your Tomcat VM to container
Start by creating a folder for your Tomcat migration artifacts:
``` bash
mkdir ~/m2c-petclinic/tomcat
cd ~/m2c-petclinic/tomcat
```

1. The first step of the migration is to copy the source VM filesystem by running the `m2c copy` command:
```bash
m2c copy gcloud -p $PROJECT_ID -z $ZONE_ID -n tomcat-petclinic -o tomcat-petclinic-fs --filters ~/filters.txt
```

2. Analyze the source VM filesystem and generate a migration plan by running the `m2c analyze` command:
``` bash
m2c analyze -s tomcat-petclinic-fs -p tomcat-container -o ./migration -r catalina-home=/opt/tomcat -r catalina-base=/opt/tomcat
```
**Note that you are using the tomcat-container type to migrate the VM which requires specifying the Tomcat CATALINA_HOME and CATALINA_BASE paths**

3. Review the migration plan by running the command:
``` bash
cat migration/config.yaml
```

4. Migrate to Containers will create a file on your local file system called **petclinic-migration.yaml**. You can now open it in cloud shell editor by running the command `edit petclinic-migration.yaml`. The migration plan should look like below:
``` yaml
# If set to true, sensitive data specified in sensitiveDataPaths will be uploaded to the artifacts repository.
includeSensitiveData: false
tomcatServers:
- name: tomcat-6e2ca1a5
  catalinaBase: /opt/tomcat
  catalinaHome: /opt/tomcat
  # Exclude files from migration.
  excludeFiles: []
  images:
  - name: tomcat-tomcat-6e2ca1a5
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/petclinic.war
    # Parent image for the generated container image.
    baseImage:
      name: tomcat:8.5-jre11-temurin
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: ""
        requests: ""
    probes:
      livenessProbe:
        tcpSocket:
          port: 8080
      readinessProbe:
        tcpSocket:
          port: 8080
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
  # Exclude files from migration.
  excludeFiles: []
  images:
  - name: tomcat-petclinic
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/petclinic.war
    # Parent image for the generated container image.
    baseImage:
      name: tomcat:8.5-jre11-temurin
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: ""
        requests: ""
    probes:
      livenessProbe:
        tcpSocket:
          port: 8080
      readinessProbe:
        tcpSocket:
          port: 8080
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
```

5. Execute the migration and generate artifacts by running the command `m2c generate`:
```bash
m2c generate -i ./migration -o ./artifacts
```

6. View the generated artifacts by running the command:
```bash
ls artifacts
```

The artifacts will be downloaded into `tomcat/tomcat-petclinic` directory which you can access by running the command `cd tomcat/tomcat-petclinic/` and it includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image for your Tomcat applications by leveraging the community Tomcat Docker image. The default image may be changed during migration by modifying `fromImage` or by modifying the `FROM` string in the Dockerfile.
* **build.sh** - The build.sh script is used to build the container image for your Tomcat by leveraging [Cloud Build](https://cloud.google.com/build). You **MUST** set an environment variable named *PROJECT_ID* with the project id which is going to store the image and optionally supply a VERSION environment variable to give your build a specific version. Once changed, you can build your container image by running the commands
``` bash
export VERSION=latest
bash build.sh
```
* **tomcat/tomcat-petclinic/deployment_spec.yaml** - The deployment_spec.yaml file contains a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated Tomcat container and expose it via a service. **Note** that the service will be exposed via **ClusterIP** by default and you may change this to a LoadBalancer in-order to make your Tomcat application available externally. Before applying the deployment yaml you **MUST** replace *<my_project>* with the project id that was used in your `build.sh` script.
* **tomcat/tomcat-petclinic/additionalFiles.tar.gz** - An archive containing any additional files that are needed by Tomcat and were specified in the migration plan.
* **tomcat/tomcat-petclinic/apps/petclinic.war** - An directory containing the Petclinic application that was selected to be migrated in the migration plan.
* **tomcat/tomcat-petclinic/tomcatServer.tar.gz** - An archive containing the original CATALINA_HOME content and it is used in the Dockerfile to override the default Tomcat settings.
* **logConfigs.tar.gz** - An archive containing log files (log4j2, log4j and logback) that were modified from logging to local filesystem to log to a console appender.
* **tomcat/tomcat-petclinic/cloudbuild.yaml** - A sample Cloud Build yaml that can be used to continously build the application from source, build a new docker image and push it to GCR.
The artifacts includes the following files:
* **skaffold.yaml** - skaffold.yaml is a configuration file that describes how to build, deploy, and test an application on Kubernetes. By using [Skaffold](https://skaffold.dev/), you can build, deploy and test your containers in a similar way across all your environments.  

**RECOMMENDED**
If you would like to expose your Tomcat via a load balancer you can modify the service definition in `deployment_spec.yaml` by adding the LoadBalancer type to the service:
<pre>
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    anthos-migrate.cloud.google.com/type: tomcat-container
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: m2c-cli-1.2.2
  name: tomcat-petclinic
spec:
  ports:
  - name: tomcat-petclinic-8080
    port: 8080
    protocol: TCP
    targetPort: 8080
  <b>type: LoadBalancer</b>
  selector:
    app: tomcat-petclinic
status:
  loadBalancer: {}
</pre>

You are now ready to [deploy](../4-deploy/README.md) your migrated containers