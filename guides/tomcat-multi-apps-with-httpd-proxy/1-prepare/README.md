# Preparing your environment

* Clone the [Spring Petclinic Github](https://github.com/spring-projects/spring-petclinic) repository by running the below command in cloud shell:  
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fspring-projects%2Fspring-petclinic.git)

* Prepare and build the application by running the command:
``` sh
curl -s https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/guides/tomcat-multi-apps-with-httpd-proxy/scripts/prepare_and_build_petclinic.sh | bash
```

* Clone the [Flow CRM Github](https://github.com/eitaneib/flow-crm-tutorial) repository by running the below commands in cloud shell:  
``` sh
cd ~/cloudshell_open
git clone https://github.com/eitaneib/flow-crm-tutorial.git
cd flow-crm-tutorial
sed -i 's/localhost/apps-mysql/g' src/main/resources/application-mysql.properties
```

* Build the application by running the command:
``` sh
# The command below is required to enable legacy ssl provider for NPM build of the UI
export NODE_OPTIONS=--openssl-legacy-provider
./mvnw package -DskipTests=true -Pproduction
```

## Set environment variables to have your GCP project id, region and zone 
```
export PROJECT_ID=your_project_id
export REGION_ID=your_region
export ZONE_ID=your_zone
```

## Install your MySQL instance
1. Create a new GCE instance to host the applications MySQL database
```
gcloud compute instances create apps-mysql --zone=$ZONE_ID --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud --machine-type=e2-medium --boot-disk-size=10GB --tags=mysql --project=$PROJECT_ID
```

2. SSH to the newly created VM by running the command  
```
gcloud compute ssh apps-mysql --project $PROJECT_ID --zone $ZONE_ID
```

3. Install MySQL by running the script [install_mysql.sh](../scripts/install_mysql.sh). Note that this script will require sudo access for installing and configuring MySQL.
```
curl -s https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/guides/tomcat-multi-apps-with-httpd-proxy/scripts/install_mysql.sh | bash
```
**Important note:** The data folder for MySQL is `/var/lib/mysql`. We will use it when we migrate the database to container.

4. Go back to cloudshell by running the command:
```
exit
```

## Install your Tomcat VM
1. Create a new GCE instance  
```
gcloud compute instances create tomcat-httpd --zone=$ZONE_ID --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud --machine-type=e2-medium --boot-disk-size=10GB --tags=http-server --project=$PROJECT_ID
```

2. Upload the Petclinic application war file to tomcat instance by running the command  
```
gcloud compute scp ~/cloudshell_open/spring-petclinic/target/petclinic.war tomcat-httpd:. --project $PROJECT_ID --zone $ZONE_ID
```

2. Upload the CRM application war file to tomcat instance by running the command  
```
gcloud compute scp ~/cloudshell_open/flow-crm-tutorial/target/flowcrm.war tomcat-httpd:. --project $PROJECT_ID --zone $ZONE_ID
```

3. SSH to the newly created VM by running the command  
```
gcloud compute ssh tomcat-httpd --project $PROJECT_ID --zone $ZONE_ID
```

4. Install tomcat by running the script [install_tomcat.sh *PETCLINIC_APP_WAR* *FLOWCRM_APP_WAR*](../scripts/install_tomcat.sh). Tomcat will install into `/opt/tomcat`, create a systemd service named **tomcat** and will deploy the war file specified as *APP_WAR* into Tomcat. Run the installation script using the below command:  
```
curl -O https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/guides/tomcat-multi-apps-with-httpd-proxy/scripts/install_tomcat.sh

chmod +x ./install_tomcat.sh

sudo ./install_tomcat.sh petclinic.war flowcrm.war
```

5. You should now verify that your Tomcat had started without issues by checking the logfile **/opt/tomcat/logs/catalina.out**

6. Verify that the applications started by running the commands below and that you receive a 200 HTTP status code for both:  
```
curl http://localhost:8080/petclinic/ -I
curl http://localhost:8080/flowcrm/login -I
```

7. Install and configure Apache2 HTTPD to proxy all requests to Tomcat by running the script [install_httpd.sh](../scripts/install_httpd.sh). The script will create two `Location` configurations, one for each application:
```
curl -O https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/guides/tomcat-multi-apps-with-httpd-proxy/scripts/install_httpd.sh

chmod +x ./install_httpd.sh

sudo ./install_httpd.sh
```

8. Verify that the applications are reachable behind the HTTPD proxy by running the commands below and that you receive a 200 HTTP status code for both:  
```
curl http://localhost/petclinic/ -I
curl http://localhost/flowcrm/login -I
```

9. Disconnect from your SSH session by running the command `exit`

10. Verify public access to your applications by following the below instructions.  

* Find the Tomcat VM public URL and open each applicaiton in your browser:
```
TOMCAT_EXTERNAL_IP=`gcloud compute instances describe tomcat-httpd   --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --project=$PROJECT_ID --zone=$ZONE_ID`

echo http://$TOMCAT_EXTERNAL_IP/petclinic/
echo http://$TOMCAT_EXTERNAL_IP/flowcrm/
```
**Note** that the credentials to login to the CRM application is *user/userpass*

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