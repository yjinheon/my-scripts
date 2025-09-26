#!/usr/bin/env bash

#### service
# b = Blob service
# f = File service
# q = Queue service
# t = Table service

### resource-types
# s = Service (서비스 전체)
# c = Container (컨테이너/큐/테이블 단위)
#o = Object (Blob/Entity/Message 단위)

### permissions
# r = Read
# w = Write
# d = Delete
# l = List
# a = Add
# c = Create
# (추가 옵션: x=Delete previous version, t=Tag, m=Move, e=Execute, o=Permanent delete)

# (권장) 키를 먼저 조회해서 넘기는 방식
RG=scv
SA=scvwebsa01

KEY=$(az storage account keys list -g "$RG" -n "$SA" --query "[0].value" -o tsv)

az storage account generate-sas \
  --account-name "$SA" \
  --account-key "$KEY" \
  --services b \
  --resource-types sco \
  --permissions rwdlac \
  --expiry 2027-09-01T00:00:00Z \
  --https-only \
  --output tsv
