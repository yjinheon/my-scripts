#!/bin/bash

PID=$(cat /home/$USER/airflow/airflow-scheduler.pid)

kill -2 $PID
exit 0
