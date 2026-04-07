#!/bin/bash

DISK_USAGE=$(df -hT | grep -vE 'Filesystem|tmpfs')
TMPFS_USAGE=$(df -hT | grep tmpfs)

DISK_THRESHOLD=2   # ideally 75 in real case
MSG=""

IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Check normal disks
while IFS= read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo "$line" | awk '{print $7}')

    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]
    then
        MSG+="High Disk Usage on $PARTITION: $USAGE% \n"
    fi
done <<< "$DISK_USAGE"

# Check tmpfs separately (optional)
while IFS= read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo "$line" | awk '{print $7}')

    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]
    then
        MSG+="TMPFS Usage on $PARTITION: $USAGE% \n"
    fi
done <<< "$TMPFS_USAGE"

echo -e "$MSG"