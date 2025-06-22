#!/bin/bash

show_usage() {
  echo "Usage: run.sh <stop|start> <core-api|admin|nlp-api|counsel-api|chat-dialogue>"
}

#매개변수 확인 시작
if [ $# -ne 2 ]; then
  show_usage
  exit 1
fi

EXEC_TYPE=$(echo $1 | tr '[:upper:]' '[:lower:]')
MODULE_NAME=$(echo $2 | tr '[:upper:]' '[:lower:]')
MODULE_NAME_UPPER=$(echo $MODULE_NAME | tr '[:lower:]' '[:upper:]')

if [ "$EXEC_TYPE" != "stop" ] && [ "$EXEC_TYPE" != "start" ]; then
  show_usage
  exit 1
fi

if [ "$MODULE_NAME" != "core-api" ] && [ "$MODULE_NAME" != "admin" ] && [ "$MODULE_NAME" != "nlp-api" ] && [ "$MODULE_NAME" != "counsel-api" ] && [ "$MODULE_NAME" != "chat-dialogue" ]; then
  show_usage
  exit 1
fi
#매개변수 확인 끝

CHATBOT_HOME="$(dirname "$(realpath "$0")" | sed 's|\(.*\)/.*|\1|')"

JAVA_HOME="${CHATBOT_HOME}/ext/jdk1.8"
PYTHON_HOME="${CHATBOT_HOME}/ext/python3.6"
NODE_HOME="${CHATBOT_HOME}/module/node"

PATH=$PATH:$NODE_HOME/bin

#추가 JVM 옵션은 개별적으로 추가할것
DEFAULT_JAVA_OPTS="-Dlog4j2.formatMsgNoLookups=true -Duser.timezone=Asia/Seoul"

if [ "$EXEC_TYPE" == "start" ]; then

  echo "Start IO-STUDIO Chatbot $MODULE_NAME_UPPER"

  if [ "$MODULE_NAME" == "core-api" ] || [ "$MODULE_NAME" == "admin" ] || [ "$MODULE_NAME" == "counsel-api" ]; then
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}.jar" | grep -v grep | awk '{print $2}')
  elif [ "$MODULE_NAME" == "nlp-api" ]; then
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}" | grep -v grep | awk '{print $2}')
  elif [ "$MODULE_NAME" == "chat-dialogue" ]; then
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}" | grep "cross-env" | grep -v grep | awk '{print $2}')
  fi

  if [[ ! -z "$PID" ]]; then
    echo "$MODULE_NAME_UPPER Already Running. (PID: $PID)"
    exit 1
  fi

  if [ "$MODULE_NAME" == "core-api" ] || [ "$MODULE_NAME" == "admin" ] || [ "$MODULE_NAME" == "counsel-api" ]; then
    nohup $JAVA_HOME/bin/java $DEFAULT_JAVA_OPTS -jar ${CHATBOT_HOME}/bin/${MODULE_NAME}.jar --thin.root=${CHATBOT_HOME}/lib --thin.offline=true --spring.config.location=file:${CHATBOT_HOME}/conf/${MODULE_NAME}/${MODULE_NAME}.yml >${CHATBOT_HOME}/logs/nohup_${MODULE_NAME}.out 2>&1 &
    sleep 10
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}.jar" | grep -v grep | awk '{print $2}')

  elif [ "$MODULE_NAME" == "nlp-api" ]; then
    nohup $PYTHON_HOME/bin/python ${CHATBOT_HOME}/bin/${MODULE_NAME}/app.py --config ${CHATBOT_HOME}/conf/${MODULE_NAME}/config.json >${CHATBOT_HOME}/logs/nohup_${MODULE_NAME}.out 2>&1 &
    sleep 10
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}" | grep -v grep | awk '{print $2}')

  elif [ "$MODULE_NAME" == "chat-dialogue" ]; then
    cd $CHATBOT_HOME/bin/$MODULE_NAME
    ${NODE_HOME}/bin/npm exec -c "cross-env NODE_ENV=production ENVIRONMENT=${CHATBOT_HOME}/conf/${MODULE_NAME}/.env next build"
    nohup ${NODE_HOME}/bin/npm exec -c "cross-env NODE_ENV=production ENVIRONMENT=${CHATBOT_HOME}/conf/${MODULE_NAME}/.env node ${CHATBOT_HOME}/bin/${MODULE_NAME}/server.js" >${CHATBOT_HOME}/logs/nohup_${MODULE_NAME}.out 2>&1 &
    sleep 3
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}" | grep "cross-env" | grep -v grep | awk '{print $2}')

  fi

  echo "IO-STUDIO Chatbot $MODULE_NAME_UPPER (PID: $PID) Started."

elif [ "$EXEC_TYPE" == "stop" ]; then

  echo "Stop IO-STUDIO Chatbot $MODULE_NAME_UPPER"

  if [ "$MODULE_NAME" == "core-api" ] || [ "$MODULE_NAME" == "admin" ] || [ "$MODULE_NAME" == "counsel-api" ]; then
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}.jar" | grep -v grep | awk '{print $2}')
  elif [ "$MODULE_NAME" == "nlp-api" ]; then
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}" | grep -v grep | awk '{print $2}')
  elif [ "$MODULE_NAME" == "chat-dialogue" ]; then
    PID=$(ps -ef | grep "${CHATBOT_HOME}/bin/${MODULE_NAME}" | grep "cross-env" | grep -v grep | awk '{print $2}')
  fi

  if [[ -z "$PID" ]]; then
    echo "$MODULE_NAME_UPPER Already Stopped."
    exit 1
  fi

  kill -TERM $PID
  echo "IO-STUDIO Chatbot $MODULE_NAME_UPPER (PID: $PID) Stopped."

else

  show_usage
  exit 1

fi

exit 0
