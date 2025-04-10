#!/bin/bash

KAFKA_HOME=/home/$USER/.local/kafka

# Kafka 서버 중지 (먼저 실행중인 인스턴스 정지)
${KAFKA_HOME}/bin/kafka-server-stop.sh
sleep 3 # 정상 종료를 위한 대기 시간

# 로그 디렉토리 설정 (server.properties에 설정된 경로와 동일해야 함)
LOG_DIR="/tmp/kraft-combined-logs"

# 기존 로그 디렉토리 초기화
rm -rf ${LOG_DIR}/*
mkdir -p ${LOG_DIR}

# 클러스터 UUID 생성
uuid=$(${KAFKA_HOME}/bin/kafka-storage.sh random-uuid)

# server.properties 파일을 사용한 포맷팅 실행
${KAFKA_HOME}/bin/kafka-storage.sh format -t ${uuid} -c ${KAFKA_HOME}/config/kraft/server.properties

echo "Logs reset complete. Cluster ID: ${uuid}"
