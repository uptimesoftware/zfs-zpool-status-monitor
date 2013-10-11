#!/bin/sh

../../apache/bin/php rcs.php -h=$UPTIME_HOSTNAME -p=$UPTIME_PORT -s=$UPTIME_PASSWORD -c=$UPTIME_REMOTE_SCRIPT -a=$UPTIME_POOL
