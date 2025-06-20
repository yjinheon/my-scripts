#!/bin/bash

######################
# Create The Cluster #
######################

minikube start \
  --cpus 3 \
  --memory 6900

#minikube addons enable storage-provisioner
#minikube addons enable ingress
#minikube addons enable default-storageclass
