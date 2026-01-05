#!/usr/bin/env bash

az aks scale --name $CLUSTER --nodepool-name userpool --node-count 2 --resource-group $RG
