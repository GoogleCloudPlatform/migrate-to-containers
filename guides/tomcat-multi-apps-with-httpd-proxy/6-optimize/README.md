# Configure an Ingress to expose your Tomcat applications
Once your migrated Tomcat applications are running in GKE, you can now expose them externally by replacing the original Apache2 proxy with an Ingress configuration. By default, when configuring an Ingress on GKE, an HTTP Load Balancer is created and mapped to your Kubernetes Services. In order for the Load Balancer to connect to your Tomcats Kubernetes Services, you will need to modify your Tomcat deployments to include a readiness probe and expose the Tomcats ports using a [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) type services.

## Updating your Tomcat containers
To update the petclinic configuration you should apply the changes in bold to the file `~/m4a-apps/tomcat/tomcat-*/tomcat-petclinic/deployment_spec.yaml`:
<pre><code class="language-yaml">
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: tomcat-petclinic
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: v1.10.0
  name: tomcat-petclinic
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tomcat-petclinic
      migrate-for-anthos-optimization: "true"
      migrate-for-anthos-version: v1.10.0
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: tomcat-petclinic
        migrate-for-anthos-optimization: "true"
        migrate-for-anthos-version: v1.10.0
    spec:
      containers:
      - image: gcr.io/${PROJECT_ID}/tomcat-petclinic:${VERSION}
        name: tomcat-petclinic
        <b>ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            port: 8080
            path: /petclinic/</b>
        resources: {}
status: {}

---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: v1.10.0
  name: tomcat-petclinic
spec:
  <b>type: NodePort</b>
  ports:
  - name: tomcat-petclinic-8080
    <b>port: 8082</b>
    protocol: TCP
    targetPort: 8080
  selector:
    app: tomcat-petclinic
status:
  loadBalancer: {}
</code>
</pre>

You can now apply these changes to your cluster by running the command:
```
sed -e "s/\${PROJECT_ID}/${PROJECT_ID}/g" -e "s/\${VERSION}/${VERSION}/g" ~/m4a-apps/tomcat/tomcat-*/tomcat-petclinic/deployment_spec.yaml | kubectl apply -f -
```

In the same manner, To update the flowcrm configuration you should apply the changes in bold to the file `~/m4a-apps/tomcat/tomcat-*/tomcat-flowcrm/deployment_spec.yaml`:
<pre><code class="language-yaml">
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: tomcat-flowcrm
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: v1.10.0
  name: tomcat-flowcrm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tomcat-flowcrm
      migrate-for-anthos-optimization: "true"
      migrate-for-anthos-version: v1.10.0
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: tomcat-flowcrm
        migrate-for-anthos-optimization: "true"
        migrate-for-anthos-version: v1.10.0
    spec:
      containers:
      - image: gcr.io/${PROJECT_ID}/tomcat-flowcrm:${VERSION}
        name: tomcat-flowcrm
        <b>ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            port: 8080
            path: /flowcrm/login</b>
        resources: {}
status: {}

---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    migrate-for-anthos-optimization: "true"
    migrate-for-anthos-version: v1.10.0
  name: tomcat-flowcrm
spec:
  <b>type: NodePort</b>
  ports:
  - name: tomcat-flowcrm-8080
    <b>port: 8081</b>
    protocol: TCP
    targetPort: 8080
  selector:
    app: tomcat-flowcrm
status:
  loadBalancer: {}
</code>
</pre>

and apply these changes to your cluster by running the command:
``` bash
sed -e "s/\${PROJECT_ID}/${PROJECT_ID}/g" -e "s/\${VERSION}/${VERSION}/g" ~/m4a-apps/tomcat/tomcat-*/tomcat-flowcrm/deployment_spec.yaml | kubectl apply -f -
```

Your Tomcat applications can now be exposed by an Ingress

## Creating an Ingress
To create an Ingress you should create a file called `~/m4a-apps/ingress.yaml` and paste the yaml below to it:
``` yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tomcat-ingress
  annotations:
    # If the class annotation is not specified it defaults to "gce".
    kubernetes.io/ingress.class: "gce"
spec:
  rules:
  - http:
      paths:
      - path: /petclinic/*
        pathType: ImplementationSpecific
        backend:
          service:
            name: tomcat-petclinic
            port:
              number: 8082
      - path: /flowcrm/*
        pathType: ImplementationSpecific
        backend:
          service:
            name: tomcat-flowcrm
            port:
              number: 8081

```

The above yaml will create an Ingress object and map the paths `/petclinic/*` and `/flowcrm/*` to their respective Kubernetes services.

You can now apply the Ingress configuration to your cluster by running the command:
``` bash
kubectl apply -f ~/m4a-apps/ingress.yaml
```

You can monitor your Ingress configuration progress by running the command:
``` bash
kubectl get ingress tomcat-ingress
```
and wait until the output from the command looks like below:
```
NAME             CLASS    HOSTS   ADDRESS          PORTS   AGE
tomcat-ingress   <none>   *       xxx.xxx.xxx.xxx   80      19h
```

## Verify your Ingress configuration
To verify your Ingress configuration you can make sure that both applications are accessible in your browser by using the external IP address of your Ingress.
To verify Petclinic open the below url in the your browser:
```
http://xxx.xxx.xxx.xxx/petclinic/
```

To verify Flowcrm open the below url in the your browser:
```
http://xxx.xxx.xxx.xxx/flowcrm/
```
**The credentials to login to flowcrm are user/userpass**

## What's next
You may want to improve the security of your migrated Tomcat applications by offloading SSL and certificates management to Google Cloud. To do so, you can follow the instructions at [Using Google-managed SSL certificates](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs) and make the neccessary changes to the Ingress configuration above to enable SSL for your migrated Tomcat applications.