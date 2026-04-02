#!/bin/bash
SERVICE_NAME="nginx"
LIMIT=1000   # 256 MB in KB
EMAIL="muhammadrehbarazmat@gmail.com"


# Get memory usage of the process
MEMORY=$(ps -C $SERVICE_NAME -o rss= | awk '{sum+=$1} END {print sum}')

if [ -z "$MEMORY" ]; then
    echo "Service not running"
else
    if [ "$MEMORY" -gt "$LIMIT" ]; then
        echo "Memory usage is $MEMORY KB. Restarting $SERVICE_NAME..."
        sudo systemctl restart $SERVICE_NAME
        #Send email
        echo "$MESSAGE" | mail -s "Nginx Restart Alert" "$Email"
    else
        echo "Memory usage is normal: $MEMORY KB"
    fi
fi

