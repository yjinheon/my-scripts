#!/bin/bash

PID=$(cat /etl/airflow/airflow-webserver.pid)

kill -2 $PID
exit 0
