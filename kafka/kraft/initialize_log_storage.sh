#!/bin/bash

KAFAKA_HOME=/home/$USER/.local/kafka
# 첫 번째 인자를 변수에 저장
CLUSTER_ID=$1

$KAFAKA_HOME/bin/kafka-storage.sh format \
  -t $CLUSTER_ID \
  -c $KAFAKA_HOME/config/kraft/server.properties
