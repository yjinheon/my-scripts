#!/usr/bin/env bash

kubectl create secret tls app-tls-secret \
  --cert=./aedata.scv.com/selfsigned.crt \
  --key=./aedata.scv.com/selfsigned.key \
  -n scv
