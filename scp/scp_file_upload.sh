#!/usr/bin/env bash

# scp_file_upload.sh
# source ./load_env.sh

source .gw.env

LOCAL_FILE=$1
scp -i "$PEM_FILE" "$LOCAL_FILE" "$USER@$HOST:$REMOTE_PATH"
