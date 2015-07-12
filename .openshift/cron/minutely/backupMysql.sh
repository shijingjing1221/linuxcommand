#!/bin/bash

today=$(date +"%Y-%m-%d")
deadlineDay=$(date +"%Y-%m-%d" --date='-30 day')
backupSqlFile=BackupSql${today}.sql
datelineSqlFile="BackupSql${deadlineDay}.sql"
backupSqlFolder=~/app-root/data/tmp
appName=$OPENSHIFT_APP_NAME
backupSql() {
   if [ ! -d "$3" ]; then
   	mkdir -p $3
   fi
   mysqldump -h $OPENSHIFT_MYSQL_DB_HOST -P ${OPENSHIFT_MYSQL_DB_PORT:-3306} -u ${OPENSHIFT_MYSQL_DB_USERNAME:-'admin'} --password="$OPENSHIFT_MYSQL_DB_PASSWORD" --complete-insert $1  > $3/$2
}

deleteSqlFile() {
	if [ ! -d "$1" ]; then
		echo "Folder "$1" is not existed, nothing to be delted"
		return 1
	fi
	FILES=$1/BackupSql*.sql
	for f in $FILES
	do
	  echo "Processing $f file..."
	  # take action on each file. $f store current file name
	  bashname=`basename $f`
	  if [ "$bashname" \< "$2" ]; then
	  	rm -f $f
	  fi
	done
}
deleteSqlFile $backupSqlFolder $datelineSqlFile
backupSql $appName $backupSqlFile $backupSqlFolder 
