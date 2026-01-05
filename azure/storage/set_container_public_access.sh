#!/usr/bin/env bash

source .env

az storage container set-permission \
  --name $COMMONBLOBSC \
  --account-name $COMMONSA \
  --public-access blob
