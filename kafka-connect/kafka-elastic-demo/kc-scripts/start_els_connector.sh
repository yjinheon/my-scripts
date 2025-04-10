#!/bin/bash
source ./common_env.sh

echo "Starting Elastic Search Sink Connector..."

$KAFKA_HOME/bin/connect-standalone.sh $KAFKA_HOME/config/connect-standalone-elastic.properties \
  $KAFKA_HOME/config/custom/elasticsearch-sink.properties
