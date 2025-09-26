#!/usr/bin/env bash

source .env
source ./helper.sh

nslookup ${PG_NAME}.postgres.database.azure.com
