#!/usr/bin/env bash

source .env

az role assignment list \
  --assignee $USER_UPN \
  --output table
