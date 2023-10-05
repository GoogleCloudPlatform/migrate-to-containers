# Assessing your workloads for containerization 

## Assessing your MySQL VM for containerization
Migrate to Containers comes with an assessment tool that assesses whether or not a VM is a good candidate for migration. This tool is called [Migration Center discovery client CLI (mcdc CLI)](https://cloud.google.com/migration-center/docs/discovery-client-cli-overview) and it is used to collect details about your running VM (collected output is stored on local file system) and then analyze the collected data and assess if the VM is a good candidate for migration.

1) In order to assess your VM for containerization using the mcdc CLI, you need to ssh into your MySQL VM instance 

2) After you are SSH'd into the VM run the following command:
``` bash
curl -s https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/scripts/assess_mcdc.sh | bash
```

**Note:** The collection script must run as root user using sudo to allow successful collection of the running VM.

The collection script will leave a file on the running VM, in the directory /var/m4a which will be used be Migrate to Containers during the migration phase and will allow automated discovery of services, network ports, etc...  
For the MySQL VM the discovery tool will discover the running MySQL instance and the port that it is using.

3) Verify that the mcdc CLI output file exists
```
ls /var/m4a
```
4) Log out of the MySQL VM
```
exit
```

## Assessing your Tomcat VM for containerization
In the same manner that you have assessed the MySQL VM you should assess your Tomcat VM.

1) To assess your VM for containerization using the mcdc CLI, you need to ssh into your Tomcat VM instance 
```
gcloud compute ssh tomcat-petclinic --project $PROJECT_ID --zone $ZONE_ID
```

2) Run the following command to collect the assessment data:
``` bash
curl -s https://raw.githubusercontent.com/GoogleCloudPlatform/migrate-to-containers/main/scripts/assess_mcdc.sh | bash
```

3) Verify that the mcdc CLI output file exists
```
ls m2c
```

4) Log out of the Tomcat VM
```
exit
```

You can view the mcdc CLI analysis report by openning the file ~/m2c/mcdc-report.html in your browser.  

You are now ready to start [migrating](../3-migrate/README.md) your VMs to containers

