#!/bin/bash

PORT=8088
echo "Stopping PyBridge API Server on port $PORT..."

# 해당 포트를 사용 중인 Python 프로세스 찾아서 종료
PID=$(lsof -t -i:$PORT)

if [ -z "$PID" ]; then
    echo "No process found on port $PORT."
else
    kill $PID
    echo "Process $PID stopped."
fi
