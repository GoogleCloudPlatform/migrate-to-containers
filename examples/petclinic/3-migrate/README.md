# Migrating your VMs to containers 

**Note:** It is useful to create a workspace for managing the migrations plans and artifacts. To create such workspace in your cloud shell environment run the commands below:
```
mkdir ~/m4a-petclinic
cd ~/m4a-petclinic
```

## Migrating your PostgreSQL VM to container
Start by creating a folder for your PostgreSQL migration artifacts:
```
mkdir postgresql
cd postgresql
```

1. Before migrating a GCE VM using Migrate for Anthos and GKE you must turn off the VM. Turn it off by running the command:  
```
gcloud compute instances stop petclinic-postgres --project $PROJECT_ID --zone $ZONE_ID
```

2. Create a migration plan using 'migctl' command line interface (this should take a couple of minutes to finish):
```
migctl migration create petclinic-db-migration --source my-ce-src --vm-id petclinic-postgres --intent ImaImageAndDatage
```
**Note that we are using the ImageAndData intent to migrate the VM and also create a persistent volume for the database data folder**

**Note:** You can check the migration plan generation using the command:
```
migctl migration status petclinic-db-migration
```

3. Download and review the migration plan by running the command:
```
migctl migration get petclinic-db-migration
```
It will create a file on your local file system called **petclinic-db-migration.yaml**. You can now open it in cloud shell editor by running the command `edit petclinic-db-migration.yaml`.

4. Modify petclinic-db-migration.yaml to create a persistent volume for the database data folder. You do so by finding the *- \<folder\>* section in the yaml file:   
```
  dataVolumes:

  # Folders to include in the data volume, e.g. "/var/lib/mysql"
  # Included folders contain data and state, and therefore are automatically excluded from a generated container image
  # Replace the placeholder with the relevant path and add more items if needed
  - folders:
    - <folder>
    pvc:
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
          # Modify the required disk size on the storage field below based on the capacity needed
            storage: 10G
```

You then need to replace `- <folder>` with `- /var/lib/postgresql/10/main` and save the file. Your modified file should look like below:
<pre>
  dataVolumes:

  # Folders to include in the data volume, e.g. "/var/lib/mysql"
  # Included folders contain data and state, and therefore are automatically excluded from a generated container image
  # Replace the placeholder with the relevant path and add more items if needed
  - folders:
    <b>- /var/lib/postgresql/10/main</b>
    pvc:
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
          # Modify the required disk size on the storage field below based on the capacity needed
            storage: 10G
</pre>

4. To update the migration plan with the folder modification you need to upload the modified yaml file. You do so by running the command:
```
migctl migration update petclinic-db-migration --file petclinic-db-migration.yaml
```

5. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
```
migctl migration generate-artifacts petclinic-db-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can check the progress of your migration by running the command:
```
migctl migration status petclinic-db-migration
```
For a more verbose output you add the flag `-v` to the command above. 

6. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command:
```
migctl migration get-artifacts petclinic-db-migration
```
The downloaded artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate for Anthos and GKE container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated PostgreSQL container and expose it via a service. It also includes a [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and a [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reserving-a-persistentvolume) for the database data folder.
* **blocklist.yaml** - The blocklist.yaml file allows you to enable/disable services that were discovered during the migration discovery phase.

7. One change that we would make to keep the service name consistent with the one expected by the Tomcat instance is to change the service name from `petclinic-postgres-postgres` to `petclinic-postgres` in the `deployment_spec.yaml` file. First run the command:
```
edit deployment_spec.yaml
```
Then find the kubernetes service named `petclinic-postgres-postgres` and remove the trailing `-postgres` from the name of the service. Save the file and you are now ready to deploy your PostgreSQL container.

## Migrating your Tomcat VM to container
Start by creating a folder for your Tomcat migration artifacts:
```
mkdir ~/m4a-petclinic/tomcat
cd ~/m4a-petclinic/tomcat
```
1. Before migrating a GCE VM using Migrate for Anthos and GKE you must turn off the VM. Turn it off by running the command:  
```
gcloud compute instances stop tomcat-petclinic --project $PROJECT_ID --zone $ZONE_ID
```

2. Create a migration plan using 'migctl' command line interface. This time you will use the `Image` intent since the Tomcat application is stateless:
```
migctl migration create petclinic-migration --source my-ce-src --vm-id tomcat-petclinic --intent Image
```

**Note:** You can check the migration plan generation using the command:
```
migctl migration status petclinic-migration
```

3. Download and review the migration plan by running the command:
```
migctl migration get petclinic-migration
```
It will create a file on your local file system called **petclinic-migration.yaml**. You can now open it in cloud shell editor by running the command `edit petclinic-migration.yaml`.

4. If you've made changes to the migration plan that was downloaded in the previous step, you need to update the migration plan by uploading the modified yaml file. You can do so by running the command:
```
migctl migration update petclinic-migration --file petclinic-migration.yaml
```

5. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
```
migctl migration generate-artifacts petclinic-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can check the progress of your migration by running the command:
```
migctl migration status petclinic-migration
```
For a more verbose output you add the flag `-v` to the command above. 

6. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command below:
```
migctl migration get-artifacts petclinic-migration
```
The downloaded artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate for Anthos and GKE container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated Tomcat container and expose it via a service. **Note** that the service will be exposed via **ClusterIP** by default and you may change this to a LoadBalancer in-order to make your Tomcat application available externally.
* **blocklist.yaml** - The blocklist.yaml file allows you to enable/disable services that were discovered during the migration discovery phase.

If you would like to expose your Tomcat via a load balancer you can modify the service definition in `deployment_spec.yaml` by adding the LoadBalancer type to the service. You should also change the protocol ffrom TCP6 to TCP:
<pre>
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: v1.7.5
  name: tomcat-1-java
spec:
  ports:
  - port: 8080
    <b>protocol: TCP</b>
    targetPort: 8080
  <b>type: LoadBalancer</b>
  selector:
    app: tomcat-1
status:
  loadBalancer: {}
</pre>

You are now ready to [deploy](../4-deploy/README.md) your migrated containers