#!/bin/bash
# backup of mysql database and site files.

# config
HOME="/home/YOUR_USERNAME"
SITEDIR="YOUR_SITE_DIRECTORY"
DBHOST="YOUR_DB_HOSTNAME"
DBUSER="YOUR_DB_USERNAME"
DBPASS="YOUR_DB_PASSWORD"
DBNAME="YOUR_DB_NAME"
NOWDATE=$(date +"%y%m%d")
NOWDAY=$(date +"%d")
BACKUPDIR="backups"
MYSQLDUMP="$(which mysqldump)"

# backup file check, delete, or creation
TARGETPATH=$HOME/$BACKUPDIR/$SITEDIR/$NOWDAY
if [ -d $TARGETPATH ]
then
rm -r $TARGETPATH
mkdir -p $TARGETPATH
else
mkdir -p $TARGETPATH
fi

# GZIP of the directory inside the target path
tar -zcf $TARGETPATH/${SITEDIR}_$NOWDATE.tar.gz ./$SITEDIR

# dump mysql database inside the target path
$MYSQLDUMP -u $DBUSER -h $DBHOST -p$DBPASS $DBNAME | gzip > $TARGETPATH/${DBNAME}_$NOWDATE.sql.gz

# print a message for the logfile
printf "$SITEDIR has been backed up" | tee -a $LOGFILE
