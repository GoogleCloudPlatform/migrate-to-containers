# Migrating your MySQL VM to container

**Note:** It is useful to create a workspace for managing the migrations plans and artifacts. To create such workspace in your cloud shell environment run the commands below:
``` bash
mkdir ~/m4a-apps
cd ~/m4a-apps
```

Start by creating a folder for your MySQL migration artifacts:
``` bash
mkdir mysql
cd mysql
```

1. Before migrating a GCE VM using Migrate to Containers you must turn off the VM. Turn it off by running the command:  
``` bash
gcloud compute instances stop apps-mysql --project $PROJECT_ID --zone $ZONE_ID
```

2. Create a migration plan using 'migctl' command line interface (this should take a couple of minutes to finish):
``` bash
migctl migration create apps-db-migration --source my-ce-src --vm-id apps-mysql --type linux-system-container
```
**Note that we are using the linux-system-container type to migrate the VM and also create a persistent volume for the database data folder**

**Note:** You can check the migration plan generation status using the command:
``` bash
migctl migration status apps-db-migration
```

3. Download and review the migration plan by running the command:
``` bash
migctl migration get apps-db-migration
```
It will create two file on your local file system called **apps-db-migration.yaml** and **apps-db-migration.data.yaml**.

4. Modify apps-db-migration.data.yaml to create a persistent volume for the database data folder. You do so by pasting the below into the yaml file:   
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

5. Enable M4A enhanced runtime by running the below command:
``` bash
sed -i 's/v2kServiceManager: false/v2kServiceManager: true/g' apps-db-migration.yaml
```

6. To update the migration plan with the folder modification you need to upload the modified yaml files. You do so by returning to cloud shell and running the command:
``` bash
migctl migration update apps-db-migration --main-config apps-db-migration.yaml --data-config apps-db-migration.data.yaml
```

7. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
``` bash
migctl migration generate-artifacts apps-db-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can check the progress of your migration by running the command:
``` bash
migctl migration status apps-db-migration
```
For a more verbose output you add the flag `-v` to the command above. 

8. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command:
``` bash
migctl migration get-artifacts apps-db-migration
```
The downloaded artifacts includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image from your VM and make it executable by leveraging the Migrate to Containers container runtime.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a working Kubernetes [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated MySQL container and expose it via a service. It also includes a [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and a [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reserving-a-persistentvolume) for the database data folder.
* **services-config.yaml** - The services-config.yaml file allows you to easily enable or disable services that were being used in the source VM.

9. One change that we would make to keep the service name consistent with the one expected by the Tomcat instance is to change the service name from `apps-mysql-mysqld` to `apps-mysql` in the `deployment_spec.yaml` file. First run the command:
``` bash
edit deployment_spec.yaml
```
Then find the kubernetes service named `apps-mysql-mysqld` and remove the trailing `-mysqld` from the name of the service. Save the file and you are now ready to deploy your MySQL container.

You are now ready to [migrate](../4-migrate-tomcat/README.md) your Tomcat applications