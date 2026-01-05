#!/usr/bin/env bash

MC_RG=$(az aks show -g $RG -n $CLUSTER --query nodeResourceGroup -o tsv)

# Ingress의 Public IP 이름 찾기(대략 ingress-nginx-controller 앞뒤로 붙음)
az network public-ip list -g $MC_RG -o table

# DNS 라벨 설정 (uniq)
az network public-ip update -g $MC_RG -n kubernetes-aa846a3f912c04a24b7971185bcafcbc --dns-name aedatascv
