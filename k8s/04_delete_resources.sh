#!/bin/bash

#kubectl delete -f 01_namespace.yaml

# kgd = kubectl get deployments

kubectl delete deployment <deployment-name> -n <namespace>
