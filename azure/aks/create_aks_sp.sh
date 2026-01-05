#!/usr/bin/env bash

AKS_NAME="scv-aks"
SP_NAME="scv-aks-sp"
AKS_RG="scv"

# AKS 리소스 ID 조회
AKS_ID=$(az aks show -n $AKS_NAME -g $AKS_RG --query id -o tsv)

echo AKS_ID : $AKS_ID

# Service Principal 생성 및 AKS Contributor 역할 부여
az ad sp create-for-rbac \
  --name $SP_NAME \
  --role "Contributor" \
  --scopes $AKS_ID

# az role assignment create \
#   --assignee $SP_NAME \
#   --role "Contributor" \
#   --scope $AKS_ID
