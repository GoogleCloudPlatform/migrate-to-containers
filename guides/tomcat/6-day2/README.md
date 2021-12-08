# Continuosly building your migrated Tomcat application
One of the main benefits of using Migrate for Anthos and GKE to modernize your workloads is that it generates artifacts which are readily usable for day2 operations, namely continuous integration (CI ) and continuous deployment (CD). In this step we will showcase how you can use Cloud Source Repositories and Cloud Build to automatically trigger a new image build on every code change pushed to the repository and then manually deploy it.
 
## Cloud Source Repositories
In order to use Cloud Source Repositories you must first set up your gcloud environment by running the command:
``` bash
gcloud init && git config --global credential.https://source.developers.google.com.helper gcloud.sh
```
When running the command you'll be prompted with a number of question, please follow the prompts to set up your cloudshell environment for accessing Cloud Source Repositories. (normally you should answer the questions with the following answers: 1, 1, 1, *project_id*, n)

### Create the repository
In order to create a new repository you should run the command:
``` bash
gcloud source repos create m4a-petclinic
``` 

### Prepare your source code
To prepare the source code before committing to the repository you should follow these steps:
1. Remove current `.git` folder from the cloned github repository
``` bash
rm -rf ~/cloudshell_open/spring-petclinic/.git
```
2. Initialize your source directory to use the newly created git repository
``` bash
cd ~/cloudshell_open/spring-petclinic/
git init
git remote add google https://source.developers.google.com/p/$PROJECT_ID/r/m4a-petclinic
```
3. Add a Cloud Build yaml file to build and push a new docker image to your container registry
``` bash
cat <<'EOF' >> cloudbuild.yaml
steps:
 - name: maven:3-jdk-8
   entrypoint: mvn
   args: ["package", "-Dmaven.test.skip=true", "-Dcheckstyle.skip"]
 - name: gcr.io/cloud-builders/docker
   args: ["build", "-t", "gcr.io/$PROJECT_ID/tomcat-petclinic:$COMMIT_SHA", "-t", "gcr.io/$PROJECT_ID/tomcat-petclinic:latest", "--build-arg=WAR_FILE=target/petclinic.war", "."]
images:
 - 'gcr.io/$PROJECT_ID/tomcat-petclinic:$COMMIT_SHA'
 - 'gcr.io/$PROJECT_ID/tomcat-petclinic:latest'
EOF
```
4. Modify the Dockerfile that was generated during the migration to take the war file as input and only deploy the specific war in the Docker image:
``` bash
cat <<'EOF' >> Dockerfile
FROM tomcat:8.5.65-jdk16-openjdk
 
# cloud build will supply the newly built WAR file at build time
ARG WAR_FILE=WAR_FILE_MUST_BE_SPECIFIED_AS_BUILD_ARG
 
# Copy all relevant files from the directory tree of the CATALINA_HOME
ADD --chown=root:root catalinaHome.tar.gz /usr/local/tomcat
 
# Copy all relevant applications from the directory tree of the CATALINA_HOME
#ADD --chown=root:root applications.tar.gz /usr/local/tomcat
# We only want to update the modified application
COPY --chown=root:root ${WAR_FILE} /usr/local/tomcat/webapps/
 
# Copy external resources and configurations
ADD --chown=root:root additionalFiles.tar.gz /
 
# Copy modified log configurations
ADD --chown=root:root logConfigs.tar.gz /usr/local/tomcat
EOF
```
5. Copy the Tomcat configuration, logging config and additional files archives that were generated during the migration:
``` bash
cp ~/m4a-petclinic/tomcat/tomcat/catalinaHome.tar.gz .
cp ~/m4a-petclinic/tomcat/tomcat/logConfigs.tar.gz .
cp ~/m4a-petclinic/tomcat/tomcat/additionalFiles.tar.gz .
```
### Commit and push your changes
1. Stage all files to be added to your git repository
``` bash
git add .
```
2. Commit your changes
``` bash
git commit -m "automatically build migrated petclinic using cloud build"
```
3. Push your changes
``` bash
git push --all google
```
### Configure Cloud Build to build a new Docker image
Create a cloud build trigger that will automatically build a new image on every push to the master branch
``` bash
gcloud beta builds triggers create cloud-source-repositories \
--repo=m4a-petclinic \
--branch-pattern=master \
--build-config=cloudbuild.yaml
```

### Make a change in your application and push it to git to trigger a build pipeline
1. Change the welcome greeting to say `Welcome Migrate` instead of `Welcome`
``` bash
sed -i 's/Welcome/Welcome Migrate/' src/main/resources/messages/messages.properties
```
2. Commit your change
``` bash
git commit -a -m "Changed welcome greeting"
```
3. Push your change
``` bash
git push --all google
```

### Monitor your build 
You can see the progress of the build using the command:
``` bash
gcloud builds list --ongoing
```
Once finished you can view your build result by using this command:
``` bash
gcloud builds list --limit 1
```

### Roll the deployment of your newly built image
1. Store the newly built image tag in an environment variable
``` bash
NEW_IMAGE=$(gcloud builds list --limit 1 | grep IMAGES | cut -d ' ' -f 2)
```
2. Update the image in your deployment_spec.yaml
``` bash
sed -i -e "s|gcr.io/$PROJECT_ID/tomcat-tomcat:v1.0.0|$NEW_IMAGE|g" deployment_spec.yaml
```
3. Roll out the new image to your GKE cluster
``` bash
kubectl apply -f ~/m4a-petclinic/tomcat/tomcat/deployment_spec.yaml
```
4. Monitor the rollout using the command:
``` bash
kubectl get pods
```
### Verify that your new image is served
1. Get the exteranl IP address for the tomcat service
``` bash
kubectl get svc tomcat
```
2. Open the application url in your browser by going to the below url:
```
http://<external-ip>:8080/petclinic/
```
3. You should now see the "Welcome Migrate" in the welcome message
