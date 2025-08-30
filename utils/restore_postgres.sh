#!/bin/bash

# Define variables for database connection details

DB_NAME="your_database_name"
DB_USER="username"
DB_HOST="your_postgres_host"
DB_PORT="5432"
BACKUP_DIR="postgres_backup"
DATE=$(date +"%Y%m%d%H%M")

# GET THE LATEST BACKUP FILE

BACKUP_FILE=$(ls -t $BACKUP_DIR | head -n 1)

echo "Latest backup file: $BACKUP_FILE"

#POSTGRES_USER="postgres"

export PGPASSWORD="your_password"

# Restore the backup
echo "Restoring the database $DB_NAME from $BACKUP_FILE..."
pg_restore -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v "$BACKUP_DIR/$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "Database restored successfully."
else
  echo "Database restoration failed!"
  exit 1
fi

unset PGPASSWORD
