#!/usr/bin/env bash

set -euo pipefail

HIVE_HOME="/opt/hive"
LOG_FILE="./hive-metastore.log"

echo "Starting Hive Metastore..."

# Start metastore
cd $HIVE_HOME
nohup ./bin/hive --service metastore >$LOG_FILE 2>&1 &

sleep 3
