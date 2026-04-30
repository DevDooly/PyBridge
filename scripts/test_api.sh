#!/bin/bash

echo "Testing PyBridge API Server..."

# Root endpoint test
echo "1. Testing Root Endpoint..."
curl -s http://localhost:8088/ | grep "Welcome to PyBridge API Server"
if [ $? -eq 0 ]; then
    echo "   [SUCCESS] Root endpoint is working."
else
    echo "   [FAILURE] Root endpoint test failed."
    exit 1
fi

# Items endpoint test
echo "2. Testing Items Endpoint..."
curl -s http://localhost:8088/items/123?q=test | grep '"item_id":123'
if [ $? -eq 0 ]; then
    echo "   [SUCCESS] Items endpoint is working."
else
    echo "   [FAILURE] Items endpoint test failed."
    exit 1
fi

# CSV Validation test
echo "3. Testing CSV Validation Endpoint..."
# 인자로 파일 경로를 받거나, 없으면 테스트용 임시 파일 생성
TEST_FILE=${1:-"$(pwd)/../test_data.csv"}

if [ ! -f "$TEST_FILE" ]; then
    echo "id,name,value" > "$TEST_FILE"
    echo "1,apple,100" >> "$TEST_FILE"
    echo "2,banana," >> "$TEST_FILE"
    CREATED_TEMP=true
fi

# GET 요청으로 쿼리 파라미터 전달
RESPONSE=$(curl -s -G --data-urlencode "file_path=$TEST_FILE" http://localhost:8088/validate-csv)

echo $RESPONSE | grep '"status":"success"'
if [ $? -eq 0 ]; then
    echo "   [SUCCESS] CSV validation endpoint is working."
    [ "$CREATED_TEMP" = true ] && rm "$TEST_FILE"
else
    echo "   [FAILURE] CSV validation endpoint test failed."
    echo "   Response: $RESPONSE"
    [ "$CREATED_TEMP" = true ] && rm "$TEST_FILE"
    exit 1
fi

echo "All tests passed!"
