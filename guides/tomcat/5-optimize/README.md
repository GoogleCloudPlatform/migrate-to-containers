# Manually scaling your Tomcat
Once your migrated Tomcat is running in GKE, you will likely need to scale it up and down to meet usage requirements. You can scale your deployment by either running the **scale** command or by modifying the deployment_spec.yaml file and reapplying it.  
To scale using the **scale** command run:
```
kubectl scale tomcat-petclinic --replicas=3
```
To scale by modifying deployment_spec.yaml you should modify the file tomcat/deployment_spec.yaml and change:  
``
replicas: 1
``  
to  
``
replicas: 3
``  
then run the command below to apply the changes:
```
kubectl apply -f tomcat/tomcat-petclinic/deployment_spec.yaml
```

Now run the command ``kubectl get pods`` and see 2 additional pods were added.

# Automatically scaling your Tomcat
You can also configure your Tomcat deployment to scale automatically as the load increases. You can do so by running the **autoscale** command:
```
kubectl autoscale deployment tomcat-petclinic --cpu-percent=50 --min=2 --max=8
```
The above command will cause GKE to automatically scale the number of pods up to 8 pods when CPU consumption is above 50% and scale down to 2 pods when CPU usage decreases below 50%.

# Rolling out application updates
You can specify your update strategy for the Tomcat deployment by adding a strategy section to the deployment spec in deployment_spec.yaml file. You should add the section right before `replica: 1` as follows:
``` yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
  replicas: 1
```
This will cause any applied changes to only allow 1 pod to be unavailable at any given time with a maximum of 2 extra pods allowed to be created while rolling out the update.  

You can then roll out a change by updating the image value in deployment_spec.yaml and apply the changes using the command:
``` bash
kubectl apply -f tomcat/tomcat-petclinic/deployment_spec.yaml
```
You can then monitor the rollout of your pods using the command:
``` bash
watch kubectl get pods
```
