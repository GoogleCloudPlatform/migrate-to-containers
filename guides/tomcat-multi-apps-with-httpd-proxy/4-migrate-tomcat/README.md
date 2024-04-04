# Migrating your Tomcat Applications to containers
Start by creating a folder for your Tomcat migration artifacts:
``` bash
mkdir ~/m2c-apps/tomcat
cd ~/m2c-apps/tomcat
```

1. The first step of the migration is to copy the source VM filesystem by running the `m2c copy` command:
```bash
m2c copy gcloud -p $PROJECT_ID -z $ZONE_ID -n tomcat-httpd -o tomcat-httpd-fs --filters ~/filters.txt
```

2. Analyze the source VM filesystem and generate a migration plan by running the `m2c analyze` command:
``` bash
m2c analyze -s tomcat-httpd-fs -p tomcat-container -o ./migration -r catalina-home=/opt/tomcat -r catalina-base=/opt/tomcat
```
**Note that you are using the tomcat-container type to migrate the VM which requires specifying the Tomcat CATALINA_HOME and CATALINA_BASE paths**

3. Review the migration plan by running the command:
``` bash
cat migration/config.yaml
```

The migration plan should look like below:
``` yaml
# If set to true, sensitive data specified in sensitiveDataPaths will be uploaded to the artifacts repository.
includeSensitiveData: false
tomcatServers:
- name: tomcat-9783cdf8
  catalinaBase: /opt/tomcat
  catalinaHome: /opt/tomcat
  # Exclude files from migration.
  excludeFiles: []
  images:
  - name: tomcat-tomcat-flowcrm-9783cdf8
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/flowcrm.war
    # Parent image for the generated container image.
    baseImage:
      name: tomcat:8.5-jre11-temurin
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: ""
        requests: ""
    probes:
      livenessProbe:
        tcpSocket:
          port: 8080
      readinessProbe:
        tcpSocket:
          port: 8080
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
  - name: tomcat-tomcat-petclinic-9783cdf8
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/petclinic.war
    # Parent image for the generated container image.
    baseImage:
      name: tomcat:8.5-jre11-temurin
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: ""
        requests: ""
    probes:
      livenessProbe:
        tcpSocket:
          port: 8080
      readinessProbe:
        tcpSocket:
          port: 8080
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
  - name: tomcat-tomcat-9783cdf8
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/flowcrm.war
    - /opt/tomcat/webapps/petclinic.war
    # Parent image for the generated container image.
    baseImage:
      name: tomcat:8.5-jre11-temurin
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: ""
        requests: ""
    probes:
      livenessProbe:
        tcpSocket:
          port: 8080
      readinessProbe:
        tcpSocket:
          port: 8080
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
```

4. The migration plan includes 3 images, one for **flowcrm**, one for **petclinic** and one for **both** applications. You may delete the image containing both applications as we are planning to run each of the applications in it's own container. You can also change the names of the images and remove the `tomcat-tomcat-` prefix and the trailing unique identifier `-9783cdf8`. Once removed and modified, your migration plan yaml should look like below:
<pre><code class="language-yaml">
# If set to true, sensitive data specified in sensitiveDataPaths will be uploaded to the artifacts repository.
includeSensitiveData: false
tomcatServers:
- name: tomcat
  catalinaBase: /opt/tomcat
  catalinaHome: /opt/tomcat
  # Exclude files from migration.
  excludeFiles: []
  images:
  - name: <b>tomcat-flowcrm</b>
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/flowcrm.war
    # Parent image for the generated container image.
    baseImage:
      name: tomcat:8.5-jre11-temurin
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: ""
        requests: ""
    probes:
      livenessProbe:
        tcpSocket:
          port: 8080
      readinessProbe:
        tcpSocket:
          port: 8080
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
  - name: <b>tomcat-petclinic</b>
    # Edit this list of application paths to define migrated applications.
    applications:
    - /opt/tomcat/webapps/petclinic.war
    # Parent image for the generated container image.
    baseImage:
      name: tomcat:8.5-jre11-temurin
    # External paths required for running the Tomcat server or apps.
    additionalFiles: []
    ports:
    - 8080
    # Log Configuration paths for the Tomcat apps.
    logConfigPaths: []
    resources:
      # Define the container initial and maximum memory.
      # 'limit' sets Tomcat Java initial and max heap sizes using the RAMPercentage flags shown on the generated Dockerfile artifact.
      memory:
        limits: ""
        requests: ""
    probes:
      livenessProbe:
        tcpSocket:
          port: 8080
      readinessProbe:
        tcpSocket:
          port: 8080
    # Sensitive data which will be filtered out of the container image.
    # If includeSensitiveData is set to true the sensitive data will be mounted on the container.
    sensitiveDataPaths: []
</code></pre>

5. Execute the migration and generate artifacts by running the command `m2c generate`:
```bash
m2c generate -i ./migration -o ./artifacts
```

6. View the generated artifacts by running the command:
```bash
ls artifacts
```

The artifacts will be downloaded into `tomcat/tomcat-petclinic` and `tomcat/tomcat-flowcrm` directories and each of them includes the following files:
* **Dockerfile** - The Dockerfile is used to build the container image for your Tomcat applications by leveraging the community Tomcat Docker image. The default image may be changed during migration by modifying `fromImage` or by modifying the `FROM` string in the Dockerfile.
* **deployment_spec.yaml** - The deployment_spec.yaml file contains a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and a matching [Service](https://kubernetes.io/docs/concepts/services-networking/service/) which are used to deploy your newly migrated Tomcat container and expose it via a service. **Note** that the service will be exposed via **ClusterIP** by default and you may change this to a LoadBalancer in-order to make your Tomcat application available externally.
* **additionalFiles.tar.gz** - An archive containing any additional files that are needed by Tomcat and were specified in the migration plan.
* **apps/petclinic.war** - A directory containing the Petclinic application that was selected to be migrated in the migration plan.
* **tomcatServer.tar.gz** - An archive containing the original CATALINA_HOME content and it is used in the Dockerfile to override the default Tomcat settings.
* **logConfigs.tar.gz** - An archive containing log files (log4j2, log4j and logback) that were modified from logging to local filesystem to log to a console appender.
* **cloudbuild.yaml** - A sample Cloud Build yaml that can be used to continously build the application from source, build a new docker image and push it to GCR.
The artifacts includes the following files:
* **skaffold.yaml** - skaffold.yaml is a configuration file that describes how to build, deploy, and test an application on Kubernetes. By using [Skaffold](https://skaffold.dev/), you can build, deploy and test your containers in a similar way across all your environments.  

You are now ready to [deploy](../5-deploy/README.md) your migrated containers