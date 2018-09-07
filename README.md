# An example-api-micro-service

A simple tutorial (or perhaps even a boiler plate to getting started)  that show cases how to use Swagger for a golang based micro-service - containerized and deployed on ICP/Kube 

### Setup tips:

- set mycluster.icp to your cluster's ip address in /etc/hosts
  example: `9.30.42.249 mycluster.icp`

<br>


- docker login to your Docker registry hosted in ICP. 
  assuming your username/password is admin/admin `docker login -u admin -p admin https://mycluster.icp:8500`

<br>

- use the kube-auth.sh script to authenticate yourself with your ICP cluster


### Steps:

1.  The Swagger file  `api.yaml`  - defines the API for our service
use http://editor.swagger.io/ to easily edit your API spec

<br>

2.  Run `./build_docker.sh`  - this generates the source code from your API spec and compiles our go program inside a  well known environment that includes the golang compiler and other packages, including swagger.  In the end it produces a packed, stripped-of-symbols binary, which gets packaged into a docker image all by itself.  (This is a reason why golang is so popular - tinier images and much safer without leaking out any intepretted code or scripts )
<br>
    - push to the kube cluster: 
     ```docker push mycluster.icp:8500/default/example-api:v1```

 - *Note*: later on, we will actually implement the API - for now, just get familiar with the process with the placeholder code that swagger generates to get you started

<br>

3. Test on the same machine by running  `./docker-test-run.sh` - this simply starts up a container using the image you built above and exposes the port 13333

 - Try out http://localhost:13333/hello

   - you will see the stubbed out response, we will implement something later.. 
<br>

4. Deploy to Kubernetes - 

-   Run create.sh  -  sets up the deployment with replica 1, we also expose the service, for convenience, via port 32002

<br>

-   Run status.sh - to see the state of your deployment and services 

<br>

5. Check things out - 

```
kubectl get deployments
kubectl get pods -o wide
```

and access the url : http://mycluster.icp:32002/hello

<br>


6).  scale out our service
```
kubectl scale deployment --replicas=2 example-api
```

7).  delete the deployment & service(s) from kubernetes

````(cd k8s;./delete.sh)````    

ensure its all cleaned up 
```(cd k8s;./status.sh)```

8). Now we will use helm to do the same thing  (Helm and its counterpart Tiller is a standard packaging mechanism, supporting a templating language and parameterization. )

Take a look at the example-chart directory.  Chart.yaml is a manifest that describes the package. templates/ describes what gets deployed.

 - run: `helm install --tls --name example1  ./example-chart`
this will create an instance of the chart - a helm "release" called 'example1'

 - run `helm status example1 --tls` to see more details of this instance
   - use the port forwarding example to test out your service

```
export POD_NAME=$(kubectl get pods --namespace default -l "app=example-chart,release=example1" -o jsonpath="{.items[0].metadata.name}")

echo "Visit http://127.0.0.1:12080 to use your application"

kubectl port-forward $POD_NAME 12080:3333
```

<br>
 - You can create a second release instance of this Helm chart: 
```helm install --tls --name example2  ./example-chart```
a helm "release" called 'example2'

 - run `helm status example2 --tls` to see more details of this instance
   - use the port forwarding example to test out your service, but _use a different port number_ (such as 12090 below)

```
  export POD_NAME=$(kubectl get pods --namespace default -l "app=example-chart,release=example2" -o jsonpath="{.items[0].metadata.name}")

  echo "Visit http://127.0.0.1:12090 to use your application"
  kubectl port-forward $POD_NAME 12090:3333
  ```

<br>
 - to cleanup:  `helm delete --tls --purge example1`
 and `helm delete --tls --purge example2` 


 ---

 So far, you have quickly understood how to use Swagger to frame your APIs, test it out locally and on kubernetes. You also got the basic idea of using Helm Charts..

In the next chapter - you will see what it means to implement some of the API and do a rolling upgrade on kubernetes as well as setting liveness and readiness probes

 ---