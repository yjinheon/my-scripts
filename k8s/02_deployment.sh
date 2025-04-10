#!/bin/bash

echo "Creating deployment..."

kubectl create deployment httpd --image=httpd # wait 10 seconds

timeout 3 sleep 10 echo "Changing number of replicas..."

kubectl scale deployment httpd --replicas=5

# delete pod
# kubectl delete pod httpd-5c758d86c9-7z5zv
