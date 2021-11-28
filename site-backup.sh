#!/bin/bash
#
# Script Name: backup-sites.sh
#
# Author: Chris Morris
# Date : November 25, 2021
#
# Description: The following script will backup your websites and mysql databases. Great for use with Wordpress builds
#              hosted on popular services (DigitalOcean, DreamHost, AWS, etc). Built for Ubuntu but useful elsewhere.
#
# Run Information: Define the User Editable Config Variables to work for your configuration. Consider running in a CRON.
#
# Error Log: Any errors or output associated with the script can be found in $TARGETPATH/log.out
#

#Config Variables (USER EDITABLE)
HOME="/home/ccmorris"
BACKUPDIR="backups"
WWWPATH="/var/www"
EMAIL="chris.morris3@gmail.com"

#Config Variables (DO NOT EDIT)
NOWDATE=$(date +"%y%m%d")
START=$(date +"%s.%N")

#Check if Target path exists. If so, delete it. Create a new target path.
TARGETPATH=$HOME/$BACKUPDIR/$NOWDATE

if [ -d $TARGETPATH ]
then
rm -r $TARGETPATH
mkdir -p $TARGETPATH
else
mkdir -p $TARGETPATH
fi


exec 3>&1 1>>$TARGETPATH/log.out 2>&1
# Capture stdout for log file 'log.out':

#Loop through mysql databases and export each as ansql file.
echo "Backing up Databases"
for DB in $(mysql -e 'show databases' -s --skip-column-names); do
    #Exclude unrelated databases
    if [[ $DB != "information_schema" && $DB != "mysql" && $DB != "performance_schema" && $DB != "sys" ]];
        then mysqldump $DB > "$TARGETPATH/$DB.sql"; echo "Backing up DB: " $DB;
    fi
done

#Copy HTML files to Backup Dir
echo "Backing up Website Data" | tee /dev/fd/3
cp -R /var/www/* $TARGETPATH

#Compress Website Data & Databases
echo "Archiving Website Data" 1>&2
tar -czf $HOME/$BACKUPDIR/www_backup_$NOWDATE.tar.gz -C $HOME/$BACKUPDIR $NOWDATE

#RUNTIME COMPLETE
END=$(date +"%s.%N")

#Total Runtime
#RUNTIME=`expr $END - $START`
RUNTIME=$(echo "$END - $START"|bc)

#Done
echo "Completed in" $RUNTIME "Seconds."
