# Assessing your workloads for containerization 

## Assessing your PostgreSQL VM for containerization
Migrate for Anthos and GKE comes with a tool that assesses whether or not a Linux VM is fit for migration. This tool is called [Linux Discovery Tool (LDT)](https://cloud.google.com/migrate/anthos/docs/linux-assessment-tool) and it is used to collect details about your running VM (collected output is stored on local file system) and then analyze the collected data and assess if the VM is good fit for migration.

In order to assess your VM for containerization using the LDT, you need to download and execute the script [assess_ldt.sh](../../../common/scripts/assess_ldt.sh) on your PostgreSQL VM instance.

**Note:** The collection script must run as root user using sudo to allow successful collection of the running VM.

The collection script will leave a file on the running VM, in the directory /var/m4a which will be used be Migrate for Anthos and GKE during the migration phase and will allow automated discovery of services, network ports, etc...  
For the PostgreSQL VM the discovery tool will discover the running PostreSQL instance and the port that it is using.

## Assessing your Tomcat VM for containerization
In the same manner that you have assessed the PostgreSQL VM you should assess your Tomcat VM.
To assess your VM for containerization using the LDT, you need to download and execute the script [assess_ldt.sh](../../../common/scripts/assess_ldt.sh) on your Tomcat VM instance.

You can view the LDT analysis using the Cloud Console UI by following the instructions in the [official documentation](https://cloud.google.com/migrate/anthos/docs/linux-assessment-tool#ldt-console). Note that the JSON file should reside in ~/m4a directory.  

You are now ready to start [migrating](../3-migrate/README.md) your VMs to containers

