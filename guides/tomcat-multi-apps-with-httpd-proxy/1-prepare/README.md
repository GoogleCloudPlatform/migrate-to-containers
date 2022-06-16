# Preparing your environment

* Clone the [Spring Petclinic Github](https://github.com/spring-projects/spring-petclinic) repository by running the below command in cloud shell:  
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fspring-projects%2Fspring-petclinic.git)

* Prepare and build the application by running the command:
``` sh
curl -s https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/tree/main/guides/tomcat-multi-apps-with-httpd-proxy/scripts/prepare_and_build_petclinic.sh | bash
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
gcloud compute instances create apps-mysql --zone=$ZONE_ID --image-family=ubuntu-1804-lts --image-project=ubuntu-os-cloud --machine-type=e2-medium --boot-disk-size=10GB --tags=mysql --project=$PROJECT_ID
```

2. SSH to the newly created VM by running the command  
```
gcloud compute ssh apps-mysql --project $PROJECT_ID --zone $ZONE_ID
```

3. Install MySQL by running the script [install_mysql.sh](../scripts/install_mysql.sh). Note that this script will require sudo access for installing and configuring MySQL.
```
sudo ./install_mysql.sh
```
**Important note:** The data folder for MySQL is `/var/lib/mysql`. We will use it when we migrate the database to container.

## Install your Tomcat VM
1. Create a new GCE instance  
```
gcloud compute instances create tomcat-httpd --zone=$ZONE_ID --image-family=ubuntu-1804-lts --image-project=ubuntu-os-cloud --machine-type=e2-medium --boot-disk-size=10GB --tags=http-server --project=$PROJECT_ID
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
sudo install_tomcat.sh petclinic.war flowcrm.war
```

5. You should now verify that your Tomcat had started without issues by checking the logfile **/opt/tomcat/logs/catalina.out**

6. Verify that the applications started by running the commands below and that you receive a 200 HTTP status code for both:  
```
curl http://localhost:8080/petclinic/ -I
curl http://localhost:8080/flowcrm/login -I
```

7. Install and configure Apache2 HTTPD to proxy all requests to Tomcat by running the script [install_httpd.sh](../scripts/install_httpd.sh). The script will create two `Location` configurations, one for each application.

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

## Install Migrate to Containers
### Install Migrate to Containers by running the script [install_m4a.sh](../../../scripts/install_m4a.sh). The script will do the following:  
* Create a GKE [processing cluster](https://cloud.google.com/migrate/containers/docs/configuring-a-cluster)
* Create a service account
* Set the right permissions for the service account created above
* Download the service account key file
* Connect to the newly created cluster.
* Install M4A on the processing cluster

To verify that M4A installation was sucessfull, run the `migctl doctor` command:
```
$ migctl doctor
[✓] Deployment
[✓] Docker registry
[✓] Artifacts repo
[!] Source Status
```

Check that you are running Migrate to Containers version 1.11.1 or newer by running the command:
```
migctl version
```
and the output should look like:
```
migctl version: 1.11.1
Migrate to Containers version: 1.11.1
```
If you are running an older version, please refer to the [official documentation](https://cloud.google.com/migrate/containers/docs/installing-migrate-components) in-order to install the latest version.

### Configure the GCE migration source you're migrating from by running the script [add_ce_source.sh](../../../scripts/add_ce_source.sh). The script will do the following:
* Create a service account
* Set the right permissions for the service account created above
* Download the service account key file
* Create a source for migration using the `migctl source create` command

To verify that M4A configuration is completed, run the `migctl doctor` command again. This time the output should show that all the components are ready:
```
$ migctl doctor
[✓] Deployment
[✓] Docker registry
[✓] Artifacts repo
[✓] Source Status
```

You are now ready to [assess](../2-assess/README.md) your workloads for containerization