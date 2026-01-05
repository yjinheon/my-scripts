#!/usr/bin/env bash
set -euo pipefail

ACR="${ACR:?set ACR}"

SERVER="$(az acr show -n "$ACR" --query loginServer -o tsv)"
repos="$(az acr repository list -n "$ACR" -o tsv || true)"

echo "LOGIN_SERVER=$SERVER"
echo "IMAGES:"
for repo in $repos; do
  tags="$(az acr repository show-tags -n "$ACR" --repository "$repo" -o tsv || true)"
  if [ -z "${tags:-}" ]; then
    echo "$SERVER/$repo:<no-tags>"
  else
    for tag in $tags; do
      echo "$SERVER/$repo:$tag"
    done
  fi
done
