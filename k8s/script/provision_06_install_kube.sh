#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# 因受限于`gcr.io/google_containers`的国内镜像版本，请慎重修改版本，比如现在aliyuncs某镜像最高版本为：
# `registry.cn-hangzhou.aliyuncs.com/google-containers/kube-apiserver-amd64:v1.7.2`

# yum list kubeadm  --showduplicates |sort -r
# yum list kubelet  --showduplicates |sort -r
# yum list kubectl  --showduplicates |sort -r

sudo sh -c "echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables"

fn_run sudo yum install -y kubeadm-1.7.2
fn_run sudo yum install -y kubelet-1.7.2
fn_run sudo yum install -y kubectl-1.7.2

sudo mkdir -p /etc/systemd/system/kubelet.service.d
sudo tee "/etc/systemd/system/kubelet.service.d/20-pod-infra-image.conf" > /dev/null <<-'EOF'
[Service]
Environment="KUBELET_EXTRA_ARGS=--pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0 --feature-gates LocalStorageCapacityIsolation=true,PersistentLocalVolumes=true"
EOF

export KUBE_ETCD_IMAGE=registry.cn-hangzhou.aliyuncs.com/google-containers/etcd-amd64:3.0.17
export KUBE_REPO_PREFIX=registry.cn-hangzhou.aliyuncs.com/google-containers

# 用config文件初始化
# 或简单使用命令行option初始化
fn_run sudo -E kubeadm init \
  --kubernetes-version=v1.7.2 \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=192.168.99.11

# 为用户vagrant设置kubectl默认配置文件
# debug use: 
#   sudo -u vagrant bash -c 'echo $(id -u):$(id -g)'
#   sudo -u root bash -c 'echo $(id -u):$(id -g)'
mkdir -p "/home/vagrant/.kube"
sudo cp -f /etc/kubernetes/admin.conf "/home/vagrant/.kube/config"
sudo -u vagrant bash -c 'sudo chown $(id -u):$(id -g) "/home/vagrant/.kube/config"'

# 为用户root设置kubectl默认配置文件
sudo mkdir -p "/root/.kube"
sudo cp -f /etc/kubernetes/admin.conf "/root/.kube/config"
sudo -u root bash -c 'sudo chown $(id -u):$(id -g) "/root/.kube/config"'

# 允许master上部署pod
# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#master-isolation
kubectl taint nodes --all node-role.kubernetes.io/master-

# TODO cronjob时区问题，需打补丁

# 安装基础服务
# TODO flannel dashboard heapster
