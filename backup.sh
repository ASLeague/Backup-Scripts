#!/bin/bash

# Set the directory where you want to store your backups
BACKUP_DIR="/home/pal/backups/"

# Set the directory you want to backup
SOURCE_DIR="/home/pal/dedicated_server/Pal/Saved"

# Set the maximum number of backup copies you want to keep
MAX_COPIES=5

# Minimum free space required (in MB) to create a new backup
MIN_SPACE_MB=50

# Function to check available disk space
check_space() {
    available_space=$(df -m "$BACKUP_DIR" | tail -1 | awk '{print $4}')
    if [ "$available_space" -lt "$MIN_SPACE_MB" ]; then
        echo "Not enough space for backup. Required: $MIN_SPACE_MB MB, available: $available_space MB."
        exit 1
    fi
}

# Function to delete the oldest backup if the maximum number is exceeded
manage_backups() {
    num_backups=$(ls -1q "$BACKUP_DIR"/*.tar.gz | wc -l)
    if [ "$num_backups" -ge "$MAX_COPIES" ]; then
        oldest_backup=$(ls -t "$BACKUP_DIR"/*.tar.gz | tail -1)
        echo "Removing oldest backup: $oldest_backup"
        rm "$oldest_backup"
    fi
}

# Function to create a new backup
create_backup() {
    timestamp=$(date +"%Y%m%d-%H%M%S")
    backup_file="$BACKUP_DIR/backup-$timestamp.tar.gz"
    tar czf "$backup_file" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
    echo "Backup created: $backup_file"
}

# Main script execution
check_space
manage_backups
create_backup
