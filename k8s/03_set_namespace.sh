#!/bin/bash

# namespace is a way to divide cluster resources between multiple users
# create a namespace
kubectl create ns my-namespace

# switch to the namespace
kubectl ns my-namespace

# kubectl ns : 전체 namespace를 보여줌
