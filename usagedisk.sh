#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DISK_THRESHOLD=20
MSG=""

IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Use process substitution instead of pipe (fix subshell issue)
while IFS= read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo "$line" | awk '{print $7}')
    FILESYSTEM=$(echo "$line" | awk '{print $1}')

    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]
    then 
        MSG+="$R Disk Usage exceeded on $FILESYSTEM ($PARTITION): $USAGE% $N\n"
    fi
done < <(df -hT | awk 'NR>1')

# Print message
echo -e "$MSG"

# Send email ONLY if alert exists
if [ -n "$MSG" ]
then
    echo -e "$MSG" | mail -s "Disk Alert - $IP" rohitkumarturangi17@gmail.com
fi