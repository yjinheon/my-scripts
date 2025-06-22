#!/bin/bash

# Define variables for database connection details
DB_NAME="rnd"
DB_USER="rnduser"
DB_HOST="adata-metadb.ckoafiitqe7y.ap-northeast-2.rds.amazonaws.com"
DB_PORT="5432" # e.g., 5432
BACKUP_DIR="postgres_backup"
DATE=$(date +"%Y%m%d%H%M")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_backup_${DATE}.sql"

# Optional: If your database requires a password, use the PGPASSWORD environment variable.
export PGPASSWORD="rnduser"

# Create the backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Run pg_dump to create a backup
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -F c -b -v -f "$BACKUP_FILE"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup successful: $BACKUP_FILE"
else
  echo "Backup failed!"
fi

# Unset the PGPASSWORD variable for security reasons
unset PGPASSWORD
