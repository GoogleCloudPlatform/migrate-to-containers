# Migrating your Tomcat Applications to containers
Start by creating a folder for your Tomcat migration artifacts:
``` bash
mkdir ~/m4a-apps/tomcat
cd ~/m4a-apps/tomcat
```
1. Before migrating a GCE VM using Migrate for Anthos and GKE you must turn off the VM. Turn it off by running the command:  
``` bash
gcloud compute instances stop tomcat-httpd --project $PROJECT_ID --zone $ZONE_ID
```

2. Create a migration plan using 'migctl' command line interface. This time you will use the `Image` intent and the `tomcat` workload-type which will only migrate the Tomcat configuration and the applications deployed on it:
``` bash
migctl migration create tomcat-migration --source my-ce-src --vm-id tomcat-httpd --intent Image --workload-type tomcat
```

**Note:** You can check the migration plan generation status using the command:
``` bash
migctl migration status tomcat-migration
```

3. Download and review the migration plan by running the command:
``` bash
migctl migration get tomcat-migration
```
It will create a file on your local file system called **tomcat-migration.yaml**. You can now open it in cloud shell editor by running the command `edit tomcat-migration.yaml`. The migration plan should look like below:
``` yaml
tomcatServers:
  - name: tomcat-1fd15834
    catalinaBase: /opt/tomcat
    catalinaHome: /opt/tomcat
    # Files to extract from the server container images into secrets
    secrets:
      - files: []
        name: ""
        path: ""
    images:
      - name: tomcat-httpd-tomcat-flowcrm-1fd15834
        # Edit this list of application paths to define migrated applications.
        applications:
          - /opt/tomcat/webapps/flowcrm.war
        # Parent image for the generated container image.
        fromImage: tomcat:8.5.65-jdk16-openjdk
        # External paths required for running the Tomcat server or apps.
        additionalFiles: []
        ports:
          - 8080
        # Log Configuration paths for the Tomcat apps.
        logConfigPaths: []
        # Secrets to mount in the container image
        secrets: []
        resources:
          # Define the container’s initial and maximum memory.
          # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
          memory:
            limit: ""
            requests: ""
      - name: tomcat-httpd-tomcat-petclinic-1fd15834
        # Edit this list of application paths to define migrated applications.
        applications:
          - /opt/tomcat/webapps/petclinic.war
        # Parent image for the generated container image.
        fromImage: tomcat:8.5.65-jdk16-openjdk
        # External paths required for running the Tomcat server or apps.
        additionalFiles: []
        ports:
          - 8080
        # Log Configuration paths for the Tomcat apps.
        logConfigPaths: []
        # Secrets to mount in the container image
        secrets: []
        resources:
          # Define the container’s initial and maximum memory.
          # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
          memory:
            limit: ""
            requests: ""
      - name: tomcat-httpd-tomcat-1fd15834
        # Edit this list of application paths to define migrated applications.
        applications:
          - /opt/tomcat/webapps/flowcrm.war
          - /opt/tomcat/webapps/petclinic.war
        # Parent image for the generated container image.
        fromImage: tomcat:8.5.65-jdk16-openjdk
        # External paths required for running the Tomcat server or apps.
        additionalFiles: []
        ports:
          - 8080
        # Log Configuration paths for the Tomcat apps.
        logConfigPaths: []
        # Secrets to mount in the container image
        secrets: []
        resources:
          # Define the container’s initial and maximum memory.
          # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
          memory:
            limit: 2048M
            requests: 1280M
```

4. The migration plan includes 3 images, one for **flowcrm**, one for **petclinic** and one for **both** application. You may delete the image containing both applications as we are planning to run each of the applications in it's own container. You can also change the names of the images and remove the `tomcat-httpd-` prefix and the trailing unique identifier `-1fd15834`. Once removed and modified, your migration plan yaml should look like below:
<pre><code class="language-yaml">
tomcatServers:
  - name: tomcat-1fd15834
    catalinaBase: /opt/tomcat
    catalinaHome: /opt/tomcat
    # Files to extract from the server container images into secrets
    secrets:
      - files: []
        name: ""
        path: ""
    images:
      - name: <b>tomcat-flowcrm</b>
        # Edit this list of application paths to define migrated applications.
        applications:
          - /opt/tomcat/webapps/flowcrm.war
        # Parent image for the generated container image.
        fromImage: tomcat:8.5.65-jdk16-openjdk
        # External paths required for running the Tomcat server or apps.
        additionalFiles: []
        ports:
          - 8080
        # Log Configuration paths for the Tomcat apps.
        logConfigPaths: []
        # Secrets to mount in the container image
        secrets: []
        resources:
          # Define the container’s initial and maximum memory.
          # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
          memory:
            limit: ""
            requests: ""
      - name: <b>tomcat-petclinic</b>
        # Edit this list of application paths to define migrated applications.
        applications:
          - /opt/tomcat/webapps/petclinic.war
        # Parent image for the generated container image.
        fromImage: tomcat:8.5.65-jdk16-openjdk
        # External paths required for running the Tomcat server or apps.
        additionalFiles: []
        ports:
          - 8080
        # Log Configuration paths for the Tomcat apps.
        logConfigPaths: []
        # Secrets to mount in the container image
        secrets: []
        resources:
          # Define the container’s initial and maximum memory.
          # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
          memory:
            limit: ""
            requests: ""
</code></pre>

5. You can now update the migration by running the command:
``` bash
migctl migration update tomcat-migration --main-config tomcat-migration.yaml
```

4. Once you are satisfied with the migration plan, you may start generating the migration artifacts. You do so by running the command:
``` bash
migctl migration generate-artifacts tomcat-migration
```
**Note:** Artifacts generation duration may vary depending on the size of the source VM disk. You can check the progress of your migration by running the command:
``` bash
migctl migration status tomcat-migration
```
For a more verbose output you add the flag `-v` to the command above. 

5. When the artifacts generation is finished. You can download the generated artifacts using the get-artifacts command below:
``` bash
migctl migration get-artifacts tomcat-migration
```
The downloaded artifacts will be downloaded into `tomcat/tomcat-xxxxxxxx` directory which you can access by running the command `cd tomcat/tomcat-*/` and it includes a folder for each application (tomcat-flowcrm and tomcat-petclinic) with the following files:
* **Dockerfile** - The Dockerfile is used to build the container image for your Tomcat application by leveraging the community Tomcat Docker image. The default image may be changed during migration by modifying `fromImage` or by modifying the `FROM` string in this Dockerfile.
* **build.sh** - The build.sh script is used to build the container image for your Tomcat by leveraging [Cloud Build](https://cloud.google.com/build). You **MUST** set an environment variable named *PROJECT_ID* with the project id which is going to store the image and optionally supply a VERSION environment variable to give your build a specific version. Once changed, you can build your container images by running the below commands for both tomcat-flowcrm and tomcat-petclinic
``` bash
export VERSION=latest
bash build.sh
```
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated Tomcat container and expose it via a service.
* **additionalFiles.tar.gz** - An archive containing any additional files that are needed by Tomcat and were specified in the migration plan.
* **apps/petclinic.war** and **apps/flowcrm.war** - A directory containing the Petclinic application or FlowCRM application for the relevant container artifact.
* **catalinaHome.tar.gz** - An archive containing the original CATALINA_HOME content and it is used in the Dockerfile to override the default Tomcat settings.
* **logConfigs.tar.gz** - An archive containing log files (log4j2, log4j and logback) that were modified from logging to local filesystem to log to a console appender.
* **cloudbuild.yaml** - A sample Cloud Build yaml that can be used to continously build the application from source, build a new docker image and push it to GCR.  

You are now ready to [deploy](../5-deploy/README.md) your migrated containers