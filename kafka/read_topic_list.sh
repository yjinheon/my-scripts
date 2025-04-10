#!/bin/bash

kafaka_home=/home/$user/.local/kafka
kafaka_properties=$kafaka_home/config/server.properties
topic_name=$1

echo "reading kafka topic"
echo "kafka home: $kafaka_home"
echo "kafka properties: $kafaka_properties"

cd $kafaka_home

bin/kafka-topics.sh --list \
  --bootstrap-server localhost:9092
