# example-api-micro-service

An example to show case how to use Swagger for a golang based micro-service - containerized and deployed on kube 

### Setup tips:

- set mycluster.icp to your cluster's ip address in /etc/hosts
  example: `9.30.42.249 mycluster.icp`

<br>


- docker login to your Docker registry hosted in ICP. 
  assuming your username/password is admin/admin `docker login -u admin -p admin https://mycluster.icp:8500`

<br>

- use the kube-auth.sh script to authenticate yourself with your ICP cluster


### Steps:
1.  Swagger file -  api.yaml  - defines the API for our service
use http://editor.swagger.io/ to easily edit your API spec

<br>

2.  Run build_docker.sh  - this generates the source code from your API spec and compiles our go program inside a  well known environment that includes the golang compiler and other packages, including swagger.  In the end it produces a packed, stripped-of-symbols binary, which gets packaged into a docker image all by itself.  This is a great 
    - push to the kube cluster: 
     ```docker push mycluster.icp:8500/default/example-api:v1```

 - *Note*: later on, we will actually implement the API - for now, just get familiar with the process with the placeholder code that swagger generates to get you started

<br>

3. Deploy to Kubernetes - 
   Run create.sh  -  sets up the deployment with replica 1, we also expose the service, for convenience, via port 32002
   Run status.sh - to see the state of your deployment and services 

<br>

4. Check things out - 
```
kubectl get deployments
kubectl get pods -o wide
```

<br>

5).  Try out http://mycluster.icp:32002/hello

- you will see the stubbed out response, we will implement something later.. 
<br>

6).  scale out our service
```
kubectl scale deployment --replicas=2 example-api
```

7).  delete the deployment & service(s) from kubernetes

```` k8s/delete.sh````