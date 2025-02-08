#!/bin/bash

echo "Elasticsearch 중지 중..."

monitor_elastic_resources() {
  echo "Elasticsearch 리소스 모니터링 시작..."

  # JVM 힙 사용량 확인
  echo "JVM 힙 사용량:"
  curl -s localhost:9200/_nodes/stats/jvm | grep -A 5 "heap"

  # 디스크 사용량 확인
  echo -e "\n디스크 사용량:"
  df -h /var/lib/elasticsearch

  # CPU 사용량 확인
  echo -e "\nElasticsearch CPU 사용량:"
  top -b -n 1 | grep elasticsearch

  # 오픈된 파일 수 확인
  echo -e "\n오픈된 파일 수:"
  lsof -p $(pgrep -f elasticsearch) | wc -l
}
