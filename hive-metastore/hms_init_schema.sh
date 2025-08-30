#!/usr/bin/env bash

set -euo pipefail

HIVE_HOME="/opt/hive-metastore"
DB_TYPE="postgres"
USER_NAME="hive"
PASSWORD="hive"

$HIVE_HOME/bin/schematool -dbType $DB_TYPE -initSchema -userName $USER_NAME -passWord $PASSWORD
