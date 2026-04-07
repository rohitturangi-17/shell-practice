#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_THRESHOLD=20
MSG=""

IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

while IFS= read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}' | tr -d '%')
    PARTITION=$(echo "$line" | awk '{print $7}')
    FILESYSTEM=$(echo "$line" | awk '{print $1}')

    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]
    then 
        MSG+="$Y Disk Usage exceeded on $N $R $FILESYSTEM ($PARTITION): $USAGE% $N\n"
    fi
done < <(df -hT | awk 'NR>1')

echo -e "$MSG"

if [ -n "$MSG" ]
then
    echo -e "$MSG" | mail -s "Disk Alert - $IP" rohitkumarturangi17@gmail.com
fi