#!/bin/bash

DATE=$(date +%Y%m%d)
BACKUP_DIR="/var/log/backup"
MYSQL_PWD=1234

# sh /etc/cron.d/data_backup.sh
# sh /etc/cron.d/data_cp.sh

mysqldump -u root --all-databases >$BACKUP_DIR/search_log_$DATE.sql
