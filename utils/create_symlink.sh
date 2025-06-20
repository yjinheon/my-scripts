#!/bin/bash

# 사용법: ./create_symlink.sh original_path link_path

ORIGINAL=$1
LINK_NAME=$2

if [ -z "$ORIGINAL" ] || [ -z "$LINK_NAME" ]; then
  echo "Usage: $0 <original_path> <link_path>"
  exit 1
fi

# Check if the original file exists
# - L means it is a symbolic link
# - e means it exists (file or directory)
if [ -L "$LINK_NAME" ] || [ -e "$LINK_NAME" ]; then
  echo "removing existing file or link at $LINK_NAME"
  rm -rf "$LINK_NAME"
fi

ln -s "$ORIGINAL" "$LINK_NAME"
echo "created symlink: $LINK_NAME -> $ORIGINAL"
