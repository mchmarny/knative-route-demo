#!/bin/sh
kubectl delete ksvc blue-green-demo
kubectl delete pr build-and-deploy
git reset --hard cleanup
git push -f
