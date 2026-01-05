#!/usr/bin/env bash

az network nsg rule list --resource-group $AKS_RG --nsg-name $AKS_NSG -o table
