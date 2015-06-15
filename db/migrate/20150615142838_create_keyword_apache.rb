class CreateKeywordApache < ActiveRecord::Migration
  def up
    @keyword = Keyword.create(name: "Apache");
    @resource_type_command = 0
    @resource_type_file = 1
    @command_names = ["sudo yum -y install httpd httpd-manual",
                      "sudo yum install httpd mod_ssl",
                      "systemctl enable httpd.service",
                      "systemctl start httpd.service",
                      "firewall-cmd --permanent --add-service=http --add-service=https; firewall-cmd --reload",
                      "sudo firewall-cmd --permanent --add-service=http --add-service=https",
                      "semanage fcontext -a -t httpd_sys_content_t '/new/location(/.*)?'",
                      "setfacl -R -m g:webmasters:rwX /var/www/html",
                      "setfacl -R -m d:g:webmasters:rwx /var/www/html",
                      "mkdir -p -m 2775 /new/docroot",
                      "chgrp webmasters /new/docroot",
                      "sudo mkdir -p /srv/{default,wwwX.example.com}/www",
                      "sudo restorecon -Rv /srv/",
                      "sudo chmod 0600 w*X.key",
                      "sudo sed -i 's/wwwX/webappX/g' /etc/httpd/conf.d/webappX.conf",
                      "sudo systemctl status -l httpd.service",
                      "sudo firewall-cmd --list-all",
                      "sudo firewall-cmd --permanent --add-service=http;sudo firewall-cmd --reload",
                      "ls -lZ /var/www/html/index.php",
                      "yum list php; sudo yum install php;",
                      "sudo tail /var/log/httpd/error_log",
                      "sudo yum install php-mysql",
                      "sudo yum install httpd mod_ssl mod_wsgi",
                      "sudo mkdir -p /srv/webappX/www",
                      "sudo cp ~/webapp.wsgi /srv/webappX/www/",
                      "sudo restorecon -Rv /srv/webappX"]
    @file_names = ["/etc/httpd/conf/httpd.conf",
                   "/etc/httpd/conf.d/*.conf",
                   "/var/www/html/",
                   "/etc/pki/tls/private/<fqdn>.key",
                   "/etc/pki/tls/certs/<fqdn>.0.csr",
                   "/etc/pki/tls/certs/<fqdn>.crt",
                   "var/www/cgi-bin/"]

    @command_names.each do |command_name|
      @resource = Resource.create(rtype: @resource_type_command, name: command_name)
      Mapper.create(keyword_id: @keyword.id, resource_id: @resource.id)
    end

    @file_names.each do |file_name|
      @resource = Resource.create(rtype: @resource_type_file, name: file_name)
      Mapper.create(keyword_id: @keyword.id, resource_id: @resource.id)
    end
  end

  def down
  end
end
