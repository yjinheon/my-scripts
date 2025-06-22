#!/bin/bash

# Define variables for database connection details

DB_NAME="rnd"
DB_USER="rnduser"
DB_HOST="adata-metadb.ckoafiitqe7y.ap-northeast-2.rds.amazonaws.com"
DB_PORT="5432"
BACKUP_DIR="postgres_backup"
DATE=$(date +"%Y%m%d%H%M")

# GET THE LATEST BACKUP FILE

BACKUP_FILE=$(ls -t $BACKUP_DIR | head -n 1)

echo "Latest backup file: $BACKUP_FILE"

#POSTGRES_USER="postgres"

export PGPASSWORD="rnduser"

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
