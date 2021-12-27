# Migrating multiple Tomcat applications tutorial 

---
**NOTE:**
This tutorial is relevant to Migrate for Anthos and GKE version 1.10.1 or newer
---
[Spring Boot Petclinic application](https://github.com/spring-projects/spring-petclinic) is a Java application built with [Spring Boot](https://spring.io/projects/spring-boot) and [Maven](https://maven.apache.org/).

[Spring Boot and Vaadin FlowCRM](https://github.com/eitaneib/flow-crm-tutorial) is a sample Java CRM application built with [Spring Boot](https://spring.io/projects/spring-boot), [Vaadin](http://vaadin.com/) and [Maven](https://maven.apache.org/).

[Apache2 HTTPD](https://httpd.apache.org/) is one of the most common and widely used open source HTTP Servers and is commonly used to front Java applications running on Tomcat and act as a reverse proxy to the upstream Tomcat instances.

In this tutorial you will deploy the two applications into a Tomcat server running on a [Google Compute Engine (GCE)](https://cloud.google.com/compute) VM and connect them to a [MySQL](https://www.mysql.com/) database running on a GCE VM. You will also deploy the Apache2 HTTPD server on the Tomcat GCE VM and configure it to reverse proxy requests to the applications running on the Tomcat instance.

You'll then use [Migrate for Anthos and GKE](https://cloud.google.com/migrate/anthos) to migrate the two applications to run each in a Tomcat app container on a [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine) cluster and generate Day2 artifacts to support modern CI/CD operations for your application. You will also migrate the MySQL database into a StatefulSt and persist it's data on a Persistent Volume Claim and lastly, you'll create an Ingress to externally expose the two applications.

## What you'll do

In this tutorial you’ll do the following:

* Prepare your Google Cloud environment
* Create a MySQL Ubuntu VM on GCE  and prepare the Petclinic and FlowCRM databases
* Build and deploy Petclinic application into Tomcat on a GCE vm
* Build and deploy FlowCRM application into Tomcat on the above GCE vm
* Install and Configure Apache2 HTTPD server on the above GCE vm
* Install and configure Migrate for Anthos and GKE
* Qualify the workloads for migration using the Migrate for Anthos and GKE [Migration Fit Assessemenet (mFIT)](https://cloud.google.com/migrate/anthos/docs/fit-assessment)
* Migrate Petclinic and FlowCRM databases vm to a container with persistent data
* Migrate Petclinic application to a Tomcat container
* Migrate FlowCRM application to a Tomcat container
* Deploy the migrated database and applications to your GKE cluster
* Configure an Ingress to expose your migrated applications
* Clean up by deleting the project

## Before you begin

For this reference guide, you need a Google Cloud project. You can create a new one, or select a project you already created:

1. Select or create a Google Cloud project.  
[GO TO THE PROJECT SELECTOR PAGE](https://console.cloud.google.com/cloud-resource-manager)

2. Enable billing for your project.  
[ENABLE BILLING](https://support.google.com/cloud/answer/6293499#enable-billing)

3. Enable the Service Management API, Service Control API, Cloud Resource Manager API, Compute Engine API, Kubernetes Engine API, Google Container Registry API, Cloud Build API, Cloud Source Repositories API.  
[ENABLE THE APIS](https://console.cloud.google.com/flows/enableapi?apiid=servicemanagement.googleapis.com%20servicecontrol.googleapis.com%20cloudresourcemanager.googleapis.com%20compute.googleapis.com%20container.googleapis.com%20containerregistry.googleapis.com%20cloudbuild.googleapis.com%20sourcerepo.googleapis.com)

## Begin your migration journey
Your migration journey consist of a number of steps:  
1. [Prepare](1-prepare/README.md) - In this step you will prepare your environment by installing MySQL and Tomcat VMs, building and deploying the application and then installing Migrate for Anthos and GKE.
2. [Assess](2-assess/README.md) - In the assess step, you will run the Migrate for Anthos and GKE fit assessement and assess whether or not your MySQL and Tomcat workloads are good fit for containerization.
3. [Migrate your MySQL](3-migrate-db/README.md) - In the first migrate step you will migrate your MySQL VM into a container and generate Day2 artifacts which can later be used in modern CI/CD pipelines.
4. [Migrate your Tomcat applications](4-migrate-tomcat/README.md) - In the second migrate step you will migrate your Tomcat applications into containers and generate Day2 artifacts which can later be used in modern CI/CD pipelines.
5. [Deploy](5-deploy/README.md) - In the deploy step you will deploy your migrated workloads into a GKE cluster and verify that your applications are working as expected.
6. [Optimize](6-optimize/README.md) - In the optimize step you will configure an Ingress to map and expose your migrated applications.

## Cleaning up
The simplest way to avoid any unexpected billing charges is to delete your GCP project. You can do so by running the command below in cloud shell:
```
gcloud projects delete $PROJECT_ID
```