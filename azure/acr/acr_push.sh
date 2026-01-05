#!/usr/bin/env bash

set -eo pipefail

ACR="${ACR}"
IMAGE_NAME="${1}"
TAG_NAME="${2}"
IMAGE_TAG="${2:IMAGE_TAG}"
PUSH_LATEST="${PUSH_LATEST:-false}"

SERVER="$(az acr show -n "$ACR" --query loginServer -o tsv)"

az acr login -n "$ACR" >/dev/null

SRC_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"
DEST_IMAGE="${SERVER}/${IMAGE_NAME}:${IMAGE_TAG}"

docker tag "$SRC_IMAGE" "$DEST_IMAGE"
docker push "$DEST_IMAGE"

#if [ "$PUSH_LATEST" = "true" ]; then
#LATEST_IMAGE="${SERVER}/${IMAGE_NAME}:${TAG_NAME}"
#docker tag "$SRC_IMAGE" "$LATEST_IMAGE"
#docker push "$LATEST_IMAGE"
#fi
