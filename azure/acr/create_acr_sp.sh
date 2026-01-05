#!/usr/bin/env bash

ACR_NAME="scvacr"
SP_NAME="jenkins-acr-sp"

# ACR 리소스 ID 얻기
ACR_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# create service principal
# SP 생성 + ACR에 푸시/풀 권한 부여
az ad sp create-for-rbac \
  --name $SP_NAME \
  --role Contributor \
  --scopes $ACR_ID \
  --sdk-auth
