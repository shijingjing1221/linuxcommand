#!/bin/bash

yesterday=$(date +"%Y-%m-%d" --date='-1 day')
backupSqlFile=BackupSql${yesterday}.sql
remoteBackupSqlFolder=app-root/data/tmp
prodSqlFolder=${OPENSHIFT_DATA_DIR}prod/
appName=$OPENSHIFT_APP_NAME
#	PROD www.linuxcommand.com
prodHost=555eeb2c5973ca5b2d000045@command-sjj.rhcloud.com
#	CI ci.linuxcommand.com
#prodHost=559e80215004460d48000047@commandci-sjj.rhcloud.com

if [ $appName == "command" ]; then
	echo "This is www.linuxcommand.cn, not need to restore from SQL"
	exit 0;
fi

deleteDatabase() {
	mysql -h $OPENSHIFT_MYSQL_DB_HOST -P ${OPENSHIFT_MYSQL_DB_PORT:-3306} -u ${OPENSHIFT_MYSQL_DB_USERNAME:-'admin'} --password="$OPENSHIFT_MYSQL_DB_PASSWORD" -D $OPENSHIFT_APP_NAME -e "DROP TABLE keywords; DROP TABLE mappers; DROP TABLE resources; " 

}

restoreFromSql() {
   if [ ! -s "$2" ]; then
   	echo "The SQL script $2 is NOT existed or empty"
   	exit 1;
   fi
   deleteDatabase
   mysql -h $OPENSHIFT_MYSQL_DB_HOST -P ${OPENSHIFT_MYSQL_DB_PORT:-3306} -u ${OPENSHIFT_MYSQL_DB_USERNAME:-'admin'} --password="$OPENSHIFT_MYSQL_DB_PASSWORD"  $1  < $2
}

copySqlFromProd() {
	if [ ! -d "$1" ]; then
		echo "Folder "$1" is not existed, will create it"
		mkdir -p $1
	else
		echo "Folder "$1" is existed, will delete all the file in it"
		rm -f $1/*
	fi
	scp -i ${OPENSHIFT_DATA_DIR}.ssh/id_rsa -o StrictHostKeyChecking=no -o "UserKnownHostsFile=${OPENSHIFT_DATA_DIR}.ssh/known_hosts"  $2:$3 $1

	return $?
}


copySqlFromProd "$prodSqlFolder" "$prodHost" "$remoteBackupSqlFolder/$backupSqlFile"
if [ $? -ne 0 ]; then
	echo "No backup SQL file on PROD, will exit this script"
	exit 1;
fi
restoreFromSql $appName $prodSqlFolder/$backupSqlFile
