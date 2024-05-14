# Migrating your VMs to containers 

## Prepare your GKE environment
Migrating the database will consist of 2 parts. The first would be the migrate the data folder into a persistent volume and the second will be migrating the database runtime into a StetefulSet.

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

## Migrating your PostgreSQL VM to container
Start by creating a folder for your PostgreSQL migration artifacts:
``` bash
mkdir postgresql
cd postgresql
```

1. The first step of the migration is to copy the source VM filesystem by running the `m2c copy` command:
```bash
m2c copy gcloud -p $PROJECT_ID -z $ZONE_ID -n petclinic-postgres -o petclinic-postgres-fs --filters ~/filters.txt
```
**Protip: Add -v to m2c commands for extra info**

2. Analyze the source VM filesystem and generate a migration plan by running the `m2c analyze` command:
``` bash
m2c analyze -s petclinic-postgres-fs -p linux-vm-container -o ./migration
```
**Note that you are using the linux-vm-container type to migrate the VM and also create a persistent volume for the database data folder**

3. Review the migration plan by running the command:
``` bash
cat migration/config.yaml
```

4. Change the migration name from `linux-system` to `petclinic-postgres` by running the command:
```bash
sed -i 's/linux-system/petclinic-postgres/g' migration/config.yaml
```

5. Add an Endpoint in the `config.yaml` to expose the PostgreSQL port(5432) as a Kubernetes service by running the command:
``` yaml
cat >> ./migration/config.yaml << EOF
  endpoints:
  - name: petclinic-postgres
    port: 5432
    protocol: TCP
EOF
```

5. Create a `dataConfig.yaml` file to create a persistent volume for the DB data folder by running the command:
``` yaml
cat > ./migration/dataConfig.yaml << EOF
volumes:
- deploymentPvcName: petclinic-db-pvc
  folders:
  - /var/lib/postgresql/14/main
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
m2c analyze -s tomcat-petclinic-fs -p linux-vm-container -o ./migration
```
**Note that you are using the linux-vm-container type to migrate the VM**

3. Review the migration plan by running the command:
``` bash
cat migration/config.yaml
```

4. Change the migration name from `linux-system` to `tomcat-petclinic` by running the command:
```bash
sed -i 's/linux-system/tomcat-petclinic/g' migration/config.yaml
```

5. Add an Endpoint in the `config.yaml` to expose the Tomcat port(8080) as a Kubernetes service by running the command:
``` yaml
cat >> ./migration/config.yaml << EOF
  endpoints:
  - name: tomcat-petclinic
    port: 8080
    protocol: TCP
EOF
```

6. Execute the migration and generate artifacts by running the command `m2c generate`:
```bash
m2c generate -i ./migration -o ./artifacts
```

6. View the generated artifacts by running the command:
```bash
ls artifacts
```

The artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate to Containers container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated Tomcat container and expose it via a service. **Note** that the service will be exposed via **ClusterIP** by default and you may change this to a LoadBalancer in-order to make your Tomcat application available externally.
* **services-config.yaml** - The services-config.yaml file allows you to easily enable or disable services that were being used in the source VM.
* **skaffold.yaml** - skaffold.yaml is a configuration file that describes how to build, deploy, and test an application on Kubernetes. By using [Skaffold](https://skaffold.dev/), you can build, deploy and test your containers in a similar way across all your environments.

If you would like to expose your Tomcat via a load balancer you can modify the service definition in `deployment_spec.yaml` by adding the LoadBalancer type to the service:
<pre>
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
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