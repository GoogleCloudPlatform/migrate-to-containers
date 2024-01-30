# Preparing your environment

* Clone the [Spring Framework Petclinic Github](https://github.com/spring-petclinic/spring-framework-petclinic) repository by running the below command in cloud shell:  
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fspring-petclinic%2Fspring-framework-petclinic.git)

* Change the application version
```bash
git checkout tags/v5.3.13
```

* Modify the pom.xml to connect to your PostgreSQL instance by running the command:
```
sed -i 's/localhost\:5432/petclinic-postgres\:5432/g' pom.xml
```

* Build the application by running the command  
```
./mvnw package -DskipTests=true -PPostgreSQL
```

## Set environment variables to have your GCP project id, region and zone 
```
export PROJECT_ID=your_project_id
export REGION_ID=your_region
export ZONE_ID=your_zone
```

## Install your PostgreSQL instance
1. Create a new GCE instance to host the Petclinic PostgreSQL database
```
gcloud compute instances create petclinic-postgres --zone=$ZONE_ID --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud --machine-type=e2-medium --boot-disk-size=10GB --tags=postgres --project=$PROJECT_ID
```

2. SSH to the newly created VM by running the command  
```
gcloud compute ssh petclinic-postgres --project $PROJECT_ID --zone $ZONE_ID
```

3. Install PostgreSQL by running the script [install_postgres.sh](../scripts/install_postgres.sh). Note that this script will require sudo access for installing and configuring PostgreSQL.
```
sudo ./install_postgres.sh
```
**Important note:** The data folder for PostgreSQL is `/var/lib/postgresql/14/main`. We will use it when we migrate the database to container.

## Install your Tomcat VM
1. Create a new GCE instance  
```
gcloud compute instances create tomcat-petclinic --zone=$ZONE_ID --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud --machine-type=e2-medium --boot-disk-size=10GB --tags=tomcat --project=$PROJECT_ID
```

2. Upload the application war file to tomcat instance by running the command  
```
gcloud compute scp ~/cloudshell_open/spring-framework-petclinic/target/petclinic.war tomcat-petclinic:. --project $PROJECT_ID --zone $ZONE_ID
```

3. SSH to the newly created VM by running the command  
```
gcloud compute ssh tomcat-petclinic --project $PROJECT_ID --zone $ZONE_ID
```

4. Install tomcat by running the script [install_tomcat.sh *APP_WAR*](../scripts/install_tomcat.sh). Tomcat will install into `/opt/tomcat`, create a systemd service named **tomcat** and will deploy the war file specified as *APP_WAR* into Tomcat. Run the installation script using the below command:  
```
sudo ./install_tomcat.sh petclinic.war
```

5. You should now verify that your Tomcat had started without issues by vhecking the logfile **/opt/tomcat/logs/catalina.out**

6. Verify that the application started by running the command below and that you receive a 200 HTTP status code:  
```
curl http://localhost:8080/petclinic/ -I
```

7. Disconnect from your SSH session by running the command `exit`

8. If you would like to enable public access to your Tomcat instance and access it from your browser you can do so by openning a firewall port to your Tomcat instance.  

* Create firewall rule to allow Tomcat public access:
```
gcloud compute firewall-rules create allow-tomcat --action allow --target-tags tomcat --source-ranges 0.0.0.0/0 --rules tcp:8080
```

* Find the Tomcat VM public URL and open it in your browser:
```
TOMCAT_EXTERNAL_IP=`gcloud compute instances describe tomcat-petclinic   --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --project=$PROJECT_ID --zone=$ZONE_ID`

echo http://$TOMCAT_EXTERNAL_IP:8080/petclinic/
```
**Note: Don't forget to remove the firewall rule when you no longer need it**

## Install Migrate to Containers CLI
### Install Migrate to Containers CLI by creating a GCE instance and installing the cli on it. The CLI instance requires a large disk which will be used to copy the file system of the source VM.
Create the GCE instance by running the command:
```
gcloud compute instances create m2c-cli --zone=$ZONE_ID --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud --machine-type=e2-medium --boot-disk-size=200GB --tags=m2c --project=$PROJECT_ID --metadata=startup-script='#! /bin/bash
curl -O "https://m2c-cli-release.storage.googleapis.com/$(curl -s https://m2c-cli-release.storage.googleapis.com/latest)/linux/amd64/m2c"
chmod +x ./m2c
mv m2c /usr/local/bin
EOF'
```

To verify that M2C CLI was installed properly, you can run the command:
```
gcloud compute ssh m2c-cli --project=$PROJECT_ID --zone=$ZONE_ID --command "m2c version"
```

The output from the command should show the M2C CLI version that was installed.

You are now ready to [assess](../2-assess/README.md) your workloads for containerization