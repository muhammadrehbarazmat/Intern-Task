#!/bin/bash

SERVICE_NAME="nginx"
LIMIT=256000   # 256 MB in KB

# Get memory usage of the process
MEMORY=$(ps -C $SERVICE_NAME -o rss= | awk '{sum+=$1} END {print sum}')

if [ -z "$MEMORY" ]; then
    echo "Service not running"
else
    if [ "$MEMORY" -gt "$LIMIT" ]; then
        echo "Memory usage is $MEMORY KB. Restarting $SERVICE_NAME..."
        sudo systemctl restart $SERVICE_NAME
    else
        echo "Memory usage is normal: $MEMORY KB"
    fi
fi

