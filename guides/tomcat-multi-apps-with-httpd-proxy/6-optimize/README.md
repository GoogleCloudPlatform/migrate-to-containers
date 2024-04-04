# Configure a Kubernetes [Gateway](https://gateway-api.sigs.k8s.io/) to expose your Tomcat applications
Once your migrated Tomcat applications are running in GKE, you can now expose them externally by replacing the original Apache2 proxy with a Kubernetes Gateway API. By default, when configuring a Gateway on GKE, a Load Balancer is created and then HTTPRoutes map to your Kubernetes Services.

## Creating a Gateway
To create a Gateway you should create a file called `~/m2c-apps/gateway.yaml` and paste the yaml below to it:
``` yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: apps-gateway
spec:
  gatewayClassName: gke-l7-gxlb
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    allowedRoutes:
      kinds:
      - kind: HTTPRoute
```

The above yaml will create a Gateway and provision a [Global external Application Load Balancer](https://cloud.google.com/load-balancing/docs/https). object and map the paths `/petclinic/*` and `/flowcrm/*` to their respective Kubernetes services.

You can now apply the Gateway configuration to your cluster by running the command:
``` bash
kubectl apply -f ~/m2c-apps/gateway.yaml
```

You can monitor your Gateway configuration progress by running the command:
``` bash
kubectl get gateway apps-gateway
```
and wait until the output from the command looks like below:
``` bash
NAME           CLASS         ADDRESS          PROGRAMMED   AGE
apps-gateway   gke-l7-gxlb   xx.xxx.xxx.xxx   True         44h
```

## Creating the HTTPRoutes
In order to map the load balancer to the applications Kubernetes services. You'll need to create an HTTPRoute for each of the applications. 

To create the HTTPRoutes you should create a file called `~/m2c-apps/httproutes.yaml` and paste the yaml below to it:
``` yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: petclinic
spec:
  parentRefs:
    - kind: Gateway
      name: apps-gateway
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /petclinic
    backendRefs:
    - name: tomcat-petclinic
      port: 8080
---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: flowcrm
spec:
  parentRefs:
    - kind: Gateway
      name: apps-gateway
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /flowcrm
    backendRefs:
    - name: tomcat-flowcrm
      port: 8080
```

You can now apply the routes configuration to your cluster by running the command:
``` bash
kubectl apply -f ~/m2c-apps/httproutes.yaml
```

## Verify your Gateway configuration
To verify your Gateway and HTTPRoutes configuration you can make sure that both applications are accessible in your browser by using the external IP address of your Gateway.
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
You may want to improve the security of your migrated Tomcat applications by offloading SSL and certificates management to Google Cloud. To do so, you can follow the instructions at [Using Google-managed SSL certificates](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs) and make the neccessary changes to the Gateway configuration above to enable SSL for your migrated Tomcat applications.