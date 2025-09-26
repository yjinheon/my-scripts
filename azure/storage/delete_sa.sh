#!/usr/bin/env bash

#set -euo pipefail

source .env

az storage account delete -g $RG -n $SA -y

echo "Done deleting storage account $SA"
