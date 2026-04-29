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

echo "All tests passed!"
