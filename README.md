# elafros-route-demo [![Build Status](https://travis-ci.org/mchmarny/elafros-route-demo.svg?branch=master)](https://travis-ci.org/mchmarny/elafros-route-demo)

Simple Elafros route demo

## Setup 

To stand up an instance of Elafros follow the [elafros-easy](https://github.com/mchmarny/elafros-easy/blob/master/README.md) guide. 


## Build and Run Locally

To build the app you can execute `make build` to build the app or alternatively you can run the build command directly

```
go build -v -o bin/elafros-route-demo
```

Run the viewer app using `make run`. Alternatively you can run it by executing the `elafros-route-demo` binary built in previous step. 

```
bin/elafros-route-demo
```

Once the server is started you can navigate to [http://127.0.0.1:8080]() to view the tweets. 


## Deploy to Elafros 

Install app on the Elafros service first you have to create an image of the app. You can build the image using GCP image build service `make push`. If successful, the `IMAGES` column from the results will include the URI of your image. If you need to update the image change `containerSpec` portion of the `app.yaml` manifest to your new image URI.

```
serviceType: container
      containerSpec:
        image: gcr.io/elafros-samples/elafros-route-demo:latest
```

To deploy the app, simply appy the manifest to the k8s cluster: 

```
kubectl apply -f deployments/app.yaml
```

Wait for the ingress to obtain a public IP

```
kubectl get ing
```

Then capture that IP using below command

> Alternativly you can create an A entry in your DNS server to point your subdomain to the IP

```
export SERVICE_IP=`kubectl get ing ttv-ela-ingress \
  -o jsonpath="{.status.loadBalancer.ingress[*]['ip']}"`

export SERVICE_HOST=`kubectl get ing ttv-ela-ingress \
  -o jsonpath="{.spec.rules[*]['host']}"`
```

And run the max prime number calculator. Higher the number the longer it will run 

```
  curl -H "Host: ${SERVICE_HOST}" http://$SERVICE_IP/
```

