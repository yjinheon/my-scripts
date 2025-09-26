#!/usr/bin/env bash

#az ad user list --output table

## object Id 중심으로
az ad user list \
  --query "[].{Name:displayName, UPN:userPrincipalName, ObjectId:id}" \
  -o table
