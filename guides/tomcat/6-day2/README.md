# Continuously building your migrated Tomcat application
One of the main benefits of using Migrate to Containers to modernize your workloads is that it generates artifacts which are readily usable for day2 operations, namely continuous integration (CI ) and continuous deployment (CD). In this step we will showcase how you can use Cloud Source Repositories and Cloud Build to automatically trigger a new image build on every code change pushed to the repository and then manually deploy it.
 
## Cloud Source Repositories
In order to use Cloud Source Repositories you must first set up your gcloud environment by running the command:
``` bash
gcloud init && git config --global credential.https://source.developers.google.com.helper gcloud.sh
```
When running the command you'll be prompted with a number of question, please follow the prompts to set up your cloudshell environment for accessing Cloud Source Repositories. (normally you should answer the questions with the following answers: 1, 1, 1, *project_id*, n)

### Create the repository
In order to create a new repository you should run the command:
``` bash
gcloud source repos create m2c-petclinic
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
git remote add google https://source.developers.google.com/p/$PROJECT_ID/r/m2c-petclinic
```
3. Copy the Cloud Build yaml file(tomcat/tomcat-petclinic/cloudbuild.yaml) to build and push a new docker image to your container registry
``` bash
cp ~/m2c-petclinic/tomcat/tomcat-petclinic/cloudbuild.yaml .
```
The Cloud Build yaml should look as below:
``` yaml
steps:
  - name: maven:3-jdk-8
    entrypoint: mvn
    args: ["clean", "package"]
  - name: gcr.io/cloud-builders/docker
    args: ["build", "-t", "gcr.io/${PROJECT_ID}/tomcat-petclinic:$COMMIT_SHA", "-t", "gcr.io/${PROJECT_ID}/tomcat-petclinic:latest", "--build-arg=PETCLINIC_WAR_APP=apps/petclinic.war", "."]
images:
  - "gcr.io/${PROJECT_ID}/tomcat-petclinic:$COMMIT_SHA"
  - "gcr.io/${PROJECT_ID}/tomcat-petclinic:latest"
```
4. Modify the application war path in cloudbuild.yaml to use the newly built war file from the `target` directory instead of the `apps` directory by running the command:
``` bash
sed -i 's/apps\/petclinic.war/target\/petclinic.war/' cloudbuild.yaml
```

5. Copy the Tomcat configuration, logging config and additional files archives that were generated during the migration:
``` bash
cp ~/m2c-petclinic/tomcat/tomcat-petclinic/catalinaHome.tar.gz .
cp ~/m2c-petclinic/tomcat/tomcat-petclinic/logConfigs.tar.gz .
cp ~/m2c-petclinic/tomcat/tomcat-petclinic/additionalFiles.tar.gz .
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
--repo=m2c-petclinic \
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
1. Roll out the new image to your GKE cluster
``` bash
skaffold deploy -d gcr.io/${PROJECT_ID}/tomcat-petclinic
```
2. Monitor the rollout using the command:
``` bash
kubectl get pods
```
### Verify that your new image is served
1. Get the external IP address for the tomcat service
``` bash
kubectl get svc tomcat-petclinic
```
2. Open the application url in your browser by going to the below url:
```
http://<external-ip>:8080/petclinic/
```
3. You should now see the "Welcome Migrate" in the welcome message
