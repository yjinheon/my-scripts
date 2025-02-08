#!/bin/bash

ELS_HOME=/home/$USER/.local/elasticsearch

echo "Starting ElasticSearch..."

$ELS_HOME/bin/elasticsearch -d
