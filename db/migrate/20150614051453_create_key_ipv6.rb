class CreateKeyIpv6 < ActiveRecord::Migration
  def up
    @keyword = Keyword.create(name: "IPv6");
    @resource_type_command = 0
    @resource_type_file = 1
    @command_names = ["nmcli dev status",
                      "nmcli con show",
                      "nmcli con show name",
                      "nmcli con add con-name name ...",
                      "nmcli con mod name ...",
                      "nmcli con reload",
                      "nmcli con up name",
                      "nmcli dev dis dev",
                      "nmcli con del name",
                      "ip addr show",
                      "hostnamectl set-hostname ...",
                      "ip link",
                      "nmcli con show",
                      "nmcli con add con-name eno1 type ethernet ifname eno1",
                      "nmcli con show",
                      "ip addr show eno1",
                      "nmcli con show eno1 | grep ipv4",
                      "nmcli con mod eno1 ipv4.addresses '192.168.0.1/24'",
                      "nmcli con mod eno1 ipv4.method manual",
                      "nmcli con down eno1",
                      "nmcli con up eno1",
                      "ip addr show dev eno1",
                      "ip route",
                      "ls /etc/sysconfig/network-scripts/ifcfg-*",
                      "cat /etc/sysconfig/network-scripts/ifcfg-eno1",
                      "echo '192.168.0.254 otherhost' >> /etc/hosts; ping otherhost",
                      "ping6 fe80::211:22ff:feaa:bbcc%eth0",
                      "ping6 ff02::1%eth0",
                      "nmcli con add con-name eno2 type ethernet ifname eno2",
                      "nmcli con add con-name eno2 type ethernet ifname eno2 ip6 2001:db8:0:1::c000:207/64 gw6 2001:db8:0:1::1 ip4 192.0.2.7/24 gw4 192.0.2.1",
                      "nmcli con show static-eth0 | grep ipv6",
                      "nmcli con mod static-eth0 ipv6.address \"2001:db8:0:1::a00:1/64 2001:db8:0:1::1\"",
                      "nmcli con mod static-eth0 +ipv6.dns 2001:4860:4860::8888",
                      "vim /etc/sysconfig/network-scripts/ifcfg-name; nmcli con reload",
                      "ip addr show eth0",
                      "ip -6 route show",
                      "ping6 -c 1 fe80::f482:dbff:fe25:6a9f%eth1",
                      "ssh fe80::f482:dbff:fe25:6a9f%eth1",
                      "tracepath6 2001:db8:0:2::451",
                      "ss -A inet -n",
                      "netstat -46n"]
    @file_names = ["/etc/resolv.conf",
                   "/etc/sysconfig/network-scripts/ifcfg-*",
                   "/etc/sysconfig/network-scripts/ifcfg-name",
                   "/etc/hostname"]

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
