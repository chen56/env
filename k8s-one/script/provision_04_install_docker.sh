#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# 1.自定义docker镜像库，可选mirror:
#   https://docker.mirrors.ustc.edu.cn
#   http://hub-mirror.c.163.com
#   https://registry.docker-cn.com
# 2.设置和kube匹配的cgroupdriver:  "exec-opts": ["native.cgroupdriver=systemd"] 
sudo mkdir -p /etc/docker/
sudo tee "/etc/docker/daemon.json" > /dev/null <<-'EOF'
{
	"registry-mirrors": ["http://hub-mirror.c.163.com"],
    "exec-opts": ["native.cgroupdriver=systemd"]    
}
EOF

# docker patch
sudo mkdir -p /usr/lib/systemd/system/docker.service.d/
sudo tee "/usr/lib/systemd/system/docker.service.d/10-iptables-patch.conf" > /dev/null <<-'EOF'
[Service]
ExecStartPost=/sbin/iptables -P FORWARD ACCEPT
EOF


fn_run sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# 也可以安装kubernetes建议的版本
# yum install -y docker-1.12.6
# yum list docker-ce  --showduplicates |sort -r

fn_run sudo yum install -y docker-ce 17.06.2
fn_run sudo systemctl enable docker
fn_run sudo systemctl start docker

# docker命令不需要sudo执行
# ref: https://docs.docker.com/engine/installation/linux/linux-postinstall/#manage-docker-as-a-non-root-user
fn_run sudo usermod -aG docker vagrant