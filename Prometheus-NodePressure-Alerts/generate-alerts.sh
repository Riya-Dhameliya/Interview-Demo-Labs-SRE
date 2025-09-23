#!/bin/bash

TARGET_USAGE=90       
FILE_PREFIX="/tmp/testfile"
FILE_SIZE="1G"       
COUNTER=1

while true; do
    # Get current usage percentage of /tmp (remove % sign)
    USAGE=$(df -h /tmp | awk 'NR==2 {gsub("%","",$5); print $5}')
    
    echo "Current /tmp usage: $USAGE%"
    
    # Stop if usage >= TARGET_USAGE
    if [ "$USAGE" -ge "$TARGET_USAGE" ]; then
        echo "Reached target usage of $TARGET_USAGE%. Stopping."
        break
    fi
    
    # Allocate a file chunk
    sudo fallocate -l $FILE_SIZE "${FILE_PREFIX}_${COUNTER}"
    echo "Created ${FILE_PREFIX}_${COUNTER} of size $FILE_SIZE"
    
    ((COUNTER++))
done
