class CreateKeyIscsi < ActiveRecord::Migration
  def up
    @key = Key.create(name: "iSCSI");
    @resource_type_command = 0
    @resource_type_file = 1
    @command_names = ["yum install -y targetcli",
                      "systemctl enable target; systemctl start target",
                      "firewall-cmd --permanent --add-port=3260/tcp",
                      "firewall-cmd --reload",
                      "fdisk /dev/vdb",
                      "pvcreate /dev/vdb1",
                      "vgcreate iSCSI_vg /dev/vdb1",
                      "vgdisplay iSCSI_vg",
                      "lvcreate -n disk1_lv -L 100m iSCSI_vg",
                      "lvdisplay iSCSI_vg/disk1_lv",
                      "targetcli /backstores/block create block1 /dev/vdb",
                      "targetcli /iscsi create iqn.2014-06.com.example:remotedisk1",
                      "targetcli /iscsi/iqn.2014-06.com.example:remotedisk1/tpg1/portals create 172.25.0.11",
                      "targetcli saveconfig",
                      "systemctl restart iscsi",
                      "iscsiadm -m discovery -t sendtargets -p target_server[:port]",
                      "iscsiadm -m node -T iqn.2014-06.com.example:serverX [-p target_server[:port]] -l",
                      "iscsiadm -m node -T iqn.2012-04.com.example:example [-p target_server[:port]] -u",
                      "iscsiadm -m node -T iqn.2012-04.com.example:example [-p target_server[:port]] -o delete",
                      "yum install -y iscsi-initiator-utils",
                      "iscsiadm -m discovery -t st -p 172.25.X.11",
                      "iscsiadm -m node -T iqn.2014-06.com.example:serverX -p 172.25.X.11 -l",
                      "lsblk",
                      "tail /var/log/messages",
                      "iscsiadm -m session -P 3",
                      "cd /var/lib/iscsi/nodes; ls -lR",
                      "less iqn.2014-06.com.example:serverX/172.25.X.11,3260,1/default",
                      "iscsiadm -m node -T iqn.2014-06.com.example:serverX -p 172.25.X.11 -u",
                      "systemctl restart iscsi",
                      "iscsiadm -m node -T iqn.2014-06.com.example:serverX -p 172.25.X.11 -o delete",
                      "mkfs -t xfs /dev/sda; blkid /dev/sda; mkdir /iscsidisk; vim /etc/fstab; mount /iscsidisk; df -h /iscsidisk"
                      ]
    @file_names = ["/etc/target/saveconfig.json",
                   "/etc/iscsi/iscsid.conf",
                   "/etc/iscsi/initiatorname.iscsi",
                   "/var/lib/iscsi/nodes/*"]
    @command_names.each do |command_name|
      @resource = Resource.create(rtype: @resource_type_command, name: command_name)
      Mapper.create(key_id: @key.id, resource_id: @resource.id)
    end
    @file_names.each do |file_name|
      @resource = Resource.create(rtype: @resource_type_file, name: file_name)
      Mapper.create(key_id: @key.id, resource_id: @resource.id)
    end
  end

  def down
  end
end
