# elafros-route-demo

Simple Elafros routing demo... mimicking common blue/green deployment pattern 

## Setup 

Stand up an instance of [latest Elafros build](https://github.com/elafros/elafros/blob/master/README.md)

## Demo

> For this demo we assume `thingz.io` is your root domain

#### Deploy app (v1 aka blue)

`kubectl apply -f deployments/stage1.yaml`

Navigate to http://route-demo.default.thingz.io to show deployed app

#### Deploy new version of the app (v2 aka green):

`kubectl apply -f deployments/stage2.yaml`

This will stage v2 (green) version by:
* Routing zero of v1 traffic to that version 
* Create named route for testing of v2

Navigate to http://v2.route-demo.default.thingz.io to show v2 version of the app 

#### Migrate portion of v1 (blew) traffic to v2 (green)

`kubectl apply -f deployments/stage3.yaml`

Refresh http://route-demo.default.thingz.io few times to show part of traffic going to v2 now

#### Send 100% of traffic to v2 (green)

`kubectl apply -f deployments/stage4.yaml`

This will send all traffic to new version and (for demo only):

* Still keep v1 (blue) entry (for speed of reverting, if ever necessary)
* Add named route to allow access to the old (blue) version of the app 

Refresh http://route-demo.default.thingz.io few more times to show that no traffic goes to v1. 
Navigate to http://v1.route-demo.default.thingz.io to show the old version still being available by named route. 


## Rebuilding Images 

Install app on the Elafros service first you have to create an image of the app. You can build the image using GCP image build service by executing `make push` command. If successful, the `IMAGES` column from the results will include the URI of your image. If you need to update the image change `containerSpec` portion of the `stage1.yaml` and `stage2.yaml` manifest to your new image URI.

```
serviceType: container
      containerSpec:
        image: gcr.io/elafros-samples/elafros-route-demo:blue
```

## Configuring DNS

Wait for the ingress to obtain a public IP, sometime takes up to 30sec. 

```
kubectl get ing
```

Then capture that IP using below command and configure an `A` entry with `*` in your DNS server to point your that IP
