# Assessing your workloads for containerization 

## Assessing your PostgreSQL VM for containerization
Migrate to Containers comes with a tool that assesses whether or not a Linux VM is fit for migration. This tool is called [Fit Assessment Tool (mfit)](https://cloud.google.com/migrate/containers/docs/fit-assessment) and it is used to collect details about your running VM (collected output is stored on local file system) and then analyze the collected data and assess if the VM is good fit for migration.

In order to assess your VM for containerization using mFit, you need to download and execute the script [assess_mfit.sh](../../../scripts/assess_mfit.sh) on your PostgreSQL VM instance.

**Note:** The collection script must run as root user using sudo to allow successful collection of the running VM.

The collection script will leave a file on the running VM, in the directory /var/m4a which will be used be Migrate to Containers during the migration phase and will allow automated discovery of services, network ports, etc...  
For the PostgreSQL VM the discovery tool will discover the running PostreSQL instance and the port that it is using.

## Assessing your Tomcat VM for containerization
In the same manner that you have assessed the PostgreSQL VM you should assess your Tomcat VM.
To assess your VM for containerization using mFit, you need to download and execute the script [assess_mfit.sh](../../../scripts/assess_mfit.sh) on your Tomcat VM instance.

You can view the assessment report using the Cloud Console UI by following the instructions in the [official documentation](https://cloud.google.com/migrate/containers/docs/fit-assessment#ldt-console). Note that the JSON file should reside in ~/m2c directory.  

You are now ready to start [migrating](../3-migrate/README.md) your VMs to containers

