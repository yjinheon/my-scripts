#!/usr/bin/env bash

export HIVE_META_HOME=/opt/hive-metastore

echo "Starting Hive Metastore..."

$HIVE_META_HOME/bin/start-metastore
