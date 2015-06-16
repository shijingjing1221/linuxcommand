class CreateKeywordMariadb < ActiveRecord::Migration
  def up

    keywords = ["MariaDB", "Database"]
    resource_type_command = 0
    resource_type_file = 1
    command_names = ["SELECT * FROM product;",
                     "yum groupinstall mariadb mariadb-client -y",
                     "systemctl start mariadb",
                     "systemctl enable mariadb",
                     "systemctl status mariadb",
                     "mysql_secure_installation",
                     "firewall-cmd --permanent --add-service=mysql; firewall-cmd --reload;",
                     "ss -tulpn | grep mysql",
                     "mysql -u root",
                     "mysql -u root -h localhost -p",
                     "show databases;",
                     "CREATE DATABASE inventory;USE inventory;",
                     "SHOW TABLES;",
                     "DESCRIBE servers;",
                     "INSERT INTO product(name,price,stock,id_category,id_manufacturer) VALUES ('SDSSDP-128G-G252.5',82.04,30,3,1)",
                     "DELETE FROM product WHERE id = 1;",
                     "UPDATE product SET price=89.90, stock=60 WHERE id = 5;",
                     "select name,price,stokck FROM product WHERE price > 100;",
                     "exit",
                     "CREATE USER mobius@localhost IDENTIFIED BY 'redhat';",
                     "SELECT host,user,password FROM user WHERE user = 'mobius';",
                     "GRANT SELECT, UPDATE, DELETE, INSERT on inventory.category to mobius@localhost ;",
                     "REVOKE SELECT, UPDATE, DELETE, INSERT on inventory.category from mobius@localhost ;",
                     "FLUSH PRIVILEGES;",
                     "SHOW GRANTS FOR root@localhost;",
                     "DROP USER mobius@localhost",
                     "CREATE USER steve@'%' identified by 'steve_password';",
                     "GRANT INSERT, UPDATE, DELETE, SELECT on inventory.* to steve@'%';",
                     "GRANT SELECT on inventory.* to steve@'%';FLUSH PRIVILEGES;",
                     "mysqldump -u root -p inventory > /backup/inventory.dump",
                     "mysqldump -u root -p --all-databases > /backup/mariadb.dump",
                     "mysqladmin variables | grep datadir",
                     "df /var/lib/mysql",
                     "vgdisplay vg0 | grep Free",
                     "FLUSH TABLES WITH READ LOCK;",
                     "lvcreate -L20G -s -n mariadb-backup /dev/vg0/mariadb",
                     "UNLOCK TABLES;",
                     "mkdir /mnt/snapshot;mount /dev/vg0/mariadb-backup /mnt/snapshot;",
                     "umount /mnt/snapshot;lvremove /dev/vg0/mariadb-backup;",
                     "systemctl stop mariadb;mysqladmin variables | grep datadir;",
                     "rm -rf /var/lib/mysql/*",
                     "mysql -u root legacy < /home/student/mariadb.dump"
                     ]
    file_names = ["/etc/my.cnf",
                  "/etc/my.cnf.d/*.cnf",
                  "/var/log/mariadb/mariadb.log",
                  "/var/lib/mysql/mysql.sock"]

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
