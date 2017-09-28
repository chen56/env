#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# yum repo
# centos repo mirror
# ref: http://mirrors.aliyun.com/help/centos

# backup
fn_run sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

# CentOS-Base.repo aliyun第一次总超时
# sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
fn_run sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo

# docker-ce.repo
fn_run sudo curl -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

sudo tee "/etc/yum.repos.d/kubernetes.repo" > /dev/null <<-'EOF'
[kubernetes]
baseurl = http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled = 1
gpgcheck = 1
gpgkey = https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
name = Kubernetes
EOF

#fn_run sudo yum update -y
yum makecache fast