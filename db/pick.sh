#!/bin/bash

remove_commands=(
    "ls"
    "cd"
    "cp"
    "vi "
    "vim "
    "mkdir"
    "mv"
    "rm"
    "touch"
    "echo"
    "service"
    "cat"
    "(gdb) "
    "(while"
    "lvcreate"
    "targetcli"
    "iscsiadm"
    "mkfs"
    "nmcli"
    "hostnamectl"
    "INSERT"
    "systemctl"
    "yum install"
    )

for command in ${remove_commands[@]};do
    echo "${command}";
    sed -i "/^${command}/ d" command_resources_name_picked.txt 
done

remove_contain_strings=(
    "classroom"
    
    )

for string in ${remove_contain_strings[@]};do
    echo "${command}";
    sed -i "/${string}/ d" command_resources_name_picked.txt 
done

sed -i "s/^sudo //g" command_resources_name_picked.txt

awk '!seen[$0]++' command_resources_name_picked.txt > command_resources_name_picked_unq.txt
sed -n '/ -/p' command_resources_name_picked_unq.txt > command_resources_name_picked_unq_matchoption.txt
