#!/bin/bash

  # Config
SOURCE_DIR="$1"
BACKUP_DIR="$HOME/backups"
LOG_FILE="$BACKUP_DIR/backup.log"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
RETENTION_DAYS=7
EMAIL="muhammadrehbarazmat@gmail.com"



# Checking input 
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi
# if source directory don't exist

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# Create DIR for backups
mkdir -p "$BACKUP_DIR"

# Convert SOURCE DIR to an absolute path 
SOURCE_DIR=$(realpath "$SOURCE_DIR")
PARENT_DIR=$(dirname "$SOURCE_DIR")
DIR_NAME=$(basename "$SOURCE_DIR")
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.tar.gz"

# performing backups 

echo "$(date) - INFO: Starting backup of $SOURCE_DIR" >> "$LOG_FILE"

tar -czf "$BACKUP_FILE" -C "$PARENT_DIR" "$DIR_NAME" 2>> "$LOG_FILE"

# Check if backup is successful 

if [ $? -eq 0 ]; then
    echo "$(date) - SUCCESS: Backup created at $BACKUP_FILE" >> "$LOG_FILE"
    echo "Backup successful: $BACKUP_FILE"
else
    ERROR_MSG="Backup failed for $SOURCE_DIR on $(date)"
    echo "$(date) - ERROR: $ERROR_MSG" >> "$LOG_FILE"
    
    #  send email if there is an error 
    if command -v mail >/dev/null 2>&1; then
        echo "$ERROR_MSG" | mail -s "Backup Failed Alert" "$EMAIL"
    else
        echo "WARNING: Mail command not found. Could not send alert." >> "$LOG_FILE"
    fi
fi


     # Find and delete files older than X days
find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "$(date) - INFO: Cleanup complete. Old backups removed." >> "$LOG_FILE"


`
