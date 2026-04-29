#!/bin/bash

APP_NAME="PyBridge API Server"
PORT=8088
LOG_FILE="server.log"

echo "Starting $APP_NAME on port $PORT..."

# 의존성 설치/업데이트
echo "Installing/Updating dependencies..."
pip install -r requirements.txt > /dev/null 2>&1

# 이미 실행 중인 프로세스가 있다면 종료 (선택 사항)
./stop.sh > /dev/null 2>&1

# nohup으로 백그라운드 실행
nohup python3 main.py --port $PORT > $LOG_FILE 2>&1 &

echo "Server started in background. Logs are being written to $LOG_FILE"
echo "PID: $!"
