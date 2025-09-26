#!/usr/bin/env bash

# 현재 로그인된 구독 전체 확인
#az account list --output table

# 현재 기본 구독만
az account show --query id -o tsv
