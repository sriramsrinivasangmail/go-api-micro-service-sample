#!/bin/sh
kubectl delete -f ./example-api-deployment.yaml
kubectl delete -f ./example-api-svc.yaml
