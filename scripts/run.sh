#!/bin/bash

APP_NAME="PyBridge API Server"
LOG_FILE="server.log"

# .env 파일에서 PORT 읽기 (없으면 기본값 8088)
ENV_FILE="../.env"
if [ -f "$ENV_FILE" ]; then
    PORT=$(grep '^PORT=' "$ENV_FILE" | cut -d '=' -f 2)
fi
PORT=${PORT:-8088}

# 실행 모드 확인 (기본값: dev)
MODE="dev"
for arg in "$@"; do
    if [ "$arg" == "--prod" ]; then
        MODE="prod"
    fi
done

echo "Starting $APP_NAME on port $PORT ($MODE mode)..."

# 가상환경 처리
VENV_DIR="../venv"
if [ ! -d "$VENV_DIR" ] || [ ! -f "$VENV_DIR/bin/activate" ]; then
    echo "Virtual environment not found or incomplete. Attempting to create..."
    python3 -m venv $VENV_DIR
    
    if [ ! -f "$VENV_DIR/bin/activate" ]; then
        echo "Error: Failed to create virtual environment. Please check if 'python3-venv' is installed."
        echo "Run: sudo apt install python3.10-venv (for Ubuntu/Debian)"
        exit 1
    fi
fi

echo "Activating virtual environment..."
source $VENV_DIR/bin/activate

# 의존성 설치/업데이트
echo "Installing/Updating dependencies..."
pip install -r ../requirements.txt > /dev/null 2>&1

# 이미 실행 중인 프로세스가 있다면 종료 (선택 사항)
./stop.sh > /dev/null 2>&1

# nohup으로 백그라운드 실행
if [ "$MODE" == "prod" ]; then
    echo "Running with Gunicorn (Production)..."
    # main.py가 있는 루트 디렉토리로 이동하여 실행 (python path 문제 방지)
    cd ..
    nohup gunicorn -c gunicorn.conf.py main:app > $LOG_FILE 2>&1 &
    cd scripts
else
    echo "Running with Uvicorn (Development Mode)..."
    nohup python ../main.py --port $PORT > ../$LOG_FILE 2>&1 &
fi

echo "Server started in background. Logs are being written to $LOG_FILE"
echo "PID: $!"
