#!/bin/bash

KAFKA_HOME=/home/$USER/.local/kafka
KAFKA_PROPERTIES=$KAFKA_HOME/config/kraft/server.properties

topic_name=$1

echo "reading kafka topic"
echo "kafka home: $KAFKA_HOME"
echo "kafka properties: $KAFKA_PROPERTIES"

cd $KAFKA_HOME

bin/kafka-topics.sh --list \
  --bootstrap-server localhost:9092
