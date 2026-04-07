#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_THRESHOLD=20
MSG=""

# Get private IP (works only in cloud like AWS)
IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Get disk usage excluding header
df -hT | awk 'NR>1 {print}' | while IFS= read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo "$line" | awk '{print $7}')
    FILESYSTEM=$(echo "$line" | awk '{print $1}')
    EMAIL=$(echo -e "$MSG" | mail -s "Disk Alert - $IP" rohitkumarturangi17@gmail.com)

    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]
    then 
        MSG+="$R Disk Usage exceeded on $FILESYSTEM ($PARTITION): $USAGE% $N\n"
    fi
done

# Print message
echo -e "$MSG"
echo -e "$EMAIL"

