#!/bin/bash

check_elastic_status() {
  echo "Elasticsearch 서비스 상태 확인 중..."

  # systemctl을 통한 서비스 상태 확인
  SERVICE_STATUS=$(systemctl is-active elasticsearch)

  if [ "$SERVICE_STATUS" == "active" ]; then
    echo "Elasticsearch 서비스가 정상적으로 실행 중입니다."

    # 클러스터 헬스 체크
    HEALTH_STATUS=$(curl -s localhost:9200/_cluster/health | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
    echo "클러스터 상태: $HEALTH_STATUS"

    # 노드 정보 확인
    echo "활성 노드 정보:"
    curl -s localhost:9200/_cat/nodes?v
  else
    echo "경고: Elasticsearch 서비스가 실행되지 않고 있습니다."
  fi
}

check_elastic_status
