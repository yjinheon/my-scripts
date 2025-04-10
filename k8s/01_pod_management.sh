#!/bin/bash

echo "Start a nginx pod"

kubectl run nginx --image=nginx

# wait 3 seconds
timeout 3 sleep 3

echo "Start a nginx pod with new name"

kubectl run nginx01 --image=nginx
