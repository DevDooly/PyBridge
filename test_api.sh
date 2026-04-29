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
# 임시 CSV 파일 생성
TEMP_CSV="test_data.csv"
echo "id,name,value" > $TEMP_CSV
echo "1,apple,100" >> $TEMP_CSV
echo "2,banana," >> $TEMP_CSV

RESPONSE=$(curl -s -X POST http://localhost:8088/validate-csv \
     -H "Content-Type: application/json" \
     -d "{\"file_path\": \"$(pwd)/$TEMP_CSV\"}")

echo $RESPONSE | grep '"status":"success"'
if [ $? -eq 0 ]; then
    echo "   [SUCCESS] CSV validation endpoint is working."
    rm $TEMP_CSV
else
    echo "   [FAILURE] CSV validation endpoint test failed."
    echo "   Response: $RESPONSE"
    rm $TEMP_CSV
    exit 1
fi

echo "All tests passed!"
