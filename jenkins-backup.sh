#!/bin/bash

# Number of days to keep backups
DAYS_TO_KEEP=4    # 0 to keep forever

# Jenkins home path
JENKINS_PATH='/var/lib/jenkins'
BACKUP_PATH='/home/backup/jenkins'

#----------------------------------------

# Create the backup folder if it doesn't exist
if [ ! -d $BACKUP_PATH ]; then
  mkdir -p $BACKUP_PATH
fi

# Change into the Jenkins home directory
cd "$JENKINS_PATH"
if [ "$(pwd)" != "$JENKINS_PATH" ]; then
  echo "Failed to change directory to Jenkins home path"
  exit 1
fi

# Backup the entire Jenkins home directory or specific directories
date=$(date -I)
tar -cvpzf $BACKUP_PATH/$date-jenkins-backup.tar.gz .

# Optionally, back up specific subdirectories like jobs, plugins, etc.
# tar -cvpzf $BACKUP_PATH/$date-jenkins-jobs.tar.gz jobs/
# tar -cvpzf $BACKUP_PATH/$date-jenkins-plugins.tar.gz plugins/
# tar -cvpzf $BACKUP_PATH/$date-jenkins-config.tar.gz config.xml

# Delete old backups
if [ "$DAYS_TO_KEEP" -gt 0 ]; then
  echo "Deleting backups older than $DAYS_TO_KEEP days"
  find $BACKUP_PATH/* -mtime +$DAYS_TO_KEEP -exec rm {} \;
fi
