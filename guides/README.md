# Migrate for Anthos and GKE walkthroughs

Each walkthrough is a self contained guide, showcasing best practices for a particular migration scenario.

## Table of Contents
* [Petclinic](./petclinic) - The petclinic guide takes you through a complete migration journey of the [Spring framework Petclinic application](https://github.com/spring-petclinic/spring-framework-petclinic) and it's database from VMs to containers running on GKE.

* [Tomcat](./tomcat) - The tomcat guide takes you through a complete migration journey of the [Spring Boot Petclinic application](https://github.com/spring-projects/spring-petclinic) and it's database from VMs to containers running on GKE. As opposed to the [Petclinic guide](./petclinic) this guide will migrate the Tomcat configuration and deployed applications into a community Tomcat Docker container and will demonstrate how you can use the migration generated artifacts to continuously build a new Docker image when your application is changed.