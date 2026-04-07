#!/bin/bash

DISK_USAGE=$(df -hT | grep -v Filesystem)
TMPFS=$(df -hT | awk '$1=="tmpfs" {print $4, $5, $6}')
DISK_THRESHOLD=2 # in project it will be 75
MSG=""
IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

while IFS= read line
do
    USAGE=$(echo $line | awk '{print $6F}' | cut -d "%" -f1)
    PARTITION=$(echo $line | awk '{print $7F}')
    if [ $USAGE -ge $DISK_THRESHOLD ]
    then
        #MSG+="High Disk Usage on $PARTITION: $USAGE % <br>" #<br> represents HTML new
        MSG+="High Disk Usage on $PARTITION: $USAGE % \n"
        echo "Listed tmps : $TMPFS"
    fi
done <<< $DISK_USAGE

echo -e $MSG