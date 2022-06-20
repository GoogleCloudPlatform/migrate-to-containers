# Migrating your VMs to containers 

**Note:** It is useful to create a workspace for managing the migrations plans and artifacts. To create such workspace in your cloud shell environment run the commands below:
``` bash
mkdir ~/m2c-petclinic
cd ~/m2c-petclinic
```

## Migrating your PostgreSQL VM to container
Start by creating a folder for your PostgreSQL migration artifacts:
``` bash
mkdir postgresql
cd postgresql
```

1. Before migrating a GCE VM using Migrate to Containers you must turn off the VM. Turn it off by running the command:  
``` bash
gcloud compute instances stop petclinic-postgres --project $PROJECT_ID --zone $ZONE_ID
```

2. Create a migration plan using 'migctl' command line interface (this should take a couple of minutes to finish):
``` bash
migctl migration create petclinic-db-migration --source my-ce-src --vm-id petclinic-postgres --type linux-system-container
```
**Note that we are using the linux-system-container type to migrate the VM and also create a persistent volume for the database data folder**

**Note:** You can check the migration plan generation using the command:
``` bash
migctl migration status petclinic-db-migration
```

3. Download and review the migration plan by running the command:
``` bash
migctl migration get petclinic-db-migration
```
It will create two file on your local file system called **petclinic-db-migration.yaml** and **petclinic-db-migration.data.yaml**.

4. Modify petclinic-db-migration.data.yaml to create a persistent volume for the database data folder. You do so by pasting the below into the yaml file:
``` yaml
volumes:
- deploymentPvcName: petclinic-db-pvc
  folders:
  - /var/lib/postgresql/10/main
  newPvc:
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 10G
```

5. Enable M2C enhanced runtime by running the below command:
``` bash
sed -i 's/v2kServiceManager: false/v2kServiceManager: true/g' petclinic-db-migration.yaml
```

6. To update the migration plan with the folder modification you need to upload the modified yaml files. You do so by returning to cloud shell and running the command:
``` bash
migctl migration update petclinic-db-migration --main-config petclinic-db-migration.yaml --data-config petclinic-db-migration.data.yaml
```

7. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
``` bash
migctl migration generate-artifacts petclinic-db-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can check the progress of your migration by running the command:
``` bash
migctl migration status petclinic-db-migration
```
For a more verbose output you add the flag `-v` to the command above. 

**Note:** This step takes several minutes, keep running the above command periodically until the status is `Completed`.

8. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command:
``` bash
migctl migration get-artifacts petclinic-db-migration
```
The downloaded artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate to Containers container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated MySQL container and expose it via a service. It also includes a [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and a [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reserving-a-persistentvolume) for the database data folder.
* **services-config.yaml** - The services-config.yaml file allows you to easily enable or disable services that were being used in the source VM.

9. One change that we would make to keep the service name consistent with the one expected by the Tomcat instance is to change the service name from `petclinic-postgres-postgres` to `petclinic-postgres` in the `deployment_spec.yaml` file. First run the command:
``` bash
edit deployment_spec.yaml
```
Then find the kubernetes service named `petclinic-postgres-postgres` and remove the trailing `-postgres` from the name of the service. Save the file and you are now ready to deploy your PostgreSQL container.

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

2. Create a migration plan using 'migctl' command line interface. This time you will use the `Image` intent since the Tomcat application is stateless:
``` bash
migctl migration create petclinic-migration --source my-ce-src --vm-id tomcat-petclinic --type linux-system-container
```

**Note:** You can check the migration plan generation using the command:
``` bash
migctl migration status petclinic-migration
```

3. Download and review the migration plan by running the command:
``` bash
migctl migration get petclinic-migration
```
It will create a file on your local file system called **petclinic-migration.yaml**. You can now open it in cloud shell editor by running the command `edit petclinic-migration.yaml`.

4. Enable M2C enhanced runtime by running the below command:
``` bash
sed -i 's/v2kServiceManager: false/v2kServiceManager: true/g' petclinic-migration.yaml
```

5. Update the migration plan by running the command:
``` bash
migctl migration update petclinic-migration --main-config petclinic-migration.yaml
```

6. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
``` bash
migctl migration generate-artifacts petclinic-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can check the progress of your migration by running the command:
``` bash
migctl migration status petclinic-migration
```
For a more verbose output you add the flag `-v` to the command above. 

7. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command below:
``` bash
migctl migration get-artifacts petclinic-migration
```
The downloaded artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate to Containers container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated Tomcat container and expose it via a service. **Note** that the service will be exposed via **ClusterIP** by default and you may change this to a LoadBalancer in-order to make your Tomcat application available externally.
* **services-config.yaml** - The services-config.yaml file allows you to easily enable or disable services that were being used in the source VM.

If you would like to expose your Tomcat via a load balancer you can modify the service definition in `deployment_spec.yaml` by adding the LoadBalancer type to the service. You should also change the protocol ffrom TCP6 to TCP:
<pre>
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: v1.11.1
  name: tomcat-petclinic-java
spec:
  ports:
  - port: 8080
    <b>protocol: TCP</b>
    targetPort: 8080
  <b>type: LoadBalancer</b>
  selector:
    app: tomcat-petclinic
status:
  loadBalancer: {}
</pre>

You are now ready to [deploy](../4-deploy/README.md) your migrated containers