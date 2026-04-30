#!/bin/bash

# PyBridge API 동시성 테스트 실행 스크립트
# 이 스크립트는 수동으로 실행하며, 서버가 실행 중이어야 합니다.

echo "Starting Concurrent Test for PyBridge API Server..."

# 가상환경 활성화 (부모 디렉토리에 venv가 있다고 가정)
if [ -d "../venv" ]; then
    source ../venv/bin/activate
else
    echo "Warning: Virtual environment not found at ../venv. Running with system python."
fi

# Python 테스트 스크립트 실행
python3 test_concurrent.py

# 가상환경 비활성화
if [ -n "$VIRTUAL_ENV" ]; then
    deactivate
fi

echo "Concurrent test finished."
