class CreateKeywordBashscript < ActiveRecord::Migration
  def up
    keywords = ["Bash Scripts Basic"]
    resource_type_command = 0
    resource_type_file = 1
    command_names = ["echo $PATH",
                     "which scirptname",
                     "./scirptname",
                     "./scirptname 2> scirptname.log",
                     'echo "$HOME"',
                     'echo "`pwd`"',
                     'full_name="$FIRST $LAST"',
                     "echo $FIRST_$LAST",
                     "echo ${FIRST}${LAST}",
                     'echo "Current time: `date`"',
                     'echo "Current time: $(date)"',
                     "TAROUTPUT=$(tar cvf /tmp/incremental_backup.tar $(find /etc -type f -mtime -1))",
                     "echo $[<EXPRESSION>]",
                     'echo $[1+1]',
                     'echo $[ (1 +1) * 2 ]',
                     'COUNT=1; echo $[$[$COUNT+1]*2]',
                     'for HOST in host1 host2 host3; do echo $HOST; done',
                     'for HOST in host{1,2,3}; do echo $HOST; done',
                     'for HOST in host{1..3}; do echo $HOST; done',
                     'for FILE in file*; do ls $FILE; done',
                     'for FILE in file{a..c}; do ls $FILE; done',
                     'for PACKAGE in $(rpm -qa | grep kernal); do each "$PACKAGE was install on $(date -d @$(rpm -q --qf "%{INSTALLTIME}\n" $PACKAGE))";done',
                     'for EVEN in $(seq 2 2 8); do echo "$EVEN"; done; echo "Who do we appreciate?"',
                     'bash -x <SCRIPTNAME>',
                     'bash -x ./filesize',
                     'bash -v ./filesize',
                     "mysql -u root -e 'SHOW DATABASES'",
                     "mysql --skip-column-names -E -u root -e 'SHOW DATABASES'",
                     "mysql --skip-column-names -E -u root -e 'SHOW DATABASES' | grep -v '^*' | grep -v '^information_schema$' | grep -v '^performance_schema$'",
                     'for DBNAME in $(mysql $FMTOPTIONS -u $DBUSER -e "$COMMAND" | grep -v ^* | grep -v information_schema | grep -v performance_schema); do',
                     'echo "Backing up \"$DBNAME\"" mysqldump -u $DBUSER $DBNAME > $BACKUPDIR/$DBNAME.dump',
                     'for DBDUMP in $BACKUPDIR/*; do ... done',
                     'for ENTRY in $(cat $NEWUSERSFILE); do...done',
                     'FIRSTNAME=$(echo $ENTRY | cut -d: -f1)',
                     "FIRSTINITIAL=$(echo $FIRSTNAME | cut -c 1 | tr 'A-Z' 'a-z')",
                     "LOWERLASTNAME=$(echo $LASTNAME | tr 'A-Z' 'a-z')",
                     "ACCTNAME=$FIRSTINITIAL$LOWERLASTNAME",
                     'useradd $ACCTNAME -c "$FIRSTNAM $LASTNAME"',
                     'TIER1COUNT=$(grep -c :1$ $NEWUSERSFILE)',
                     'TIER1PCT=$[ $TIER1COUNT * 100 / $TOTAL ]'
                     ]
    file_names = [""]

    keywordModels = []
    resourceModels = []
    keywords.each do |keywordString|
      keywordModel = Keyword.create(name: keywordString);
      keywordModels.push(keywordModel)
    end
    command_names.each do |command_name|
      resource = Resource.create(rtype: resource_type_command, name: command_name)
      resourceModels.push(resource)
    end

    file_names.each do |file_name|
      resource = Resource.create(rtype: resource_type_file, name: file_name)
      resourceModels.push(resource)
    end

    keywordModels.each do |keywordModel|
      resourceModels.each do |resourceModel|
        Mapper.create(keyword_id: keywordModel.id, resource_id: resourceModel.id)
      end
    end

  end

  def down
  end
end
