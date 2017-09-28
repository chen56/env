#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# fn_run sudo systemctl disable firewalld
fn_run sudo systemctl stop firewalld
fn_run sudo systemctl disable firewalld

# disable SELinux 临时
fn_run sudo setenforce 0

# disable SELinux 持久
fn_info "/etc/selinux/config : SELINUX=disabled "
sudo sed -i "s/^SELINUX\s*=\s*\(.*\)$/SELINUX=disabled/g" /etc/selinux/config
cat /etc/selinux/config

# Docker从1.13版本开始调整了默认的防火墙规则，禁用了iptables filter表中FOWARD链，
# 这样会引起Kubernetes集群中跨Node的Pod无法通信
fn_run sudo iptables -P FORWARD ACCEPT