#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# 预先下载kubernetes所需版本的image
#
# 预下载原因：
# `kubeadm init`可能会在这一步休克，没任何提示：
# [apiclient] Created API client, waiting for the control plane to become ready
#
# 如果先pull image,这一步大概30秒：
# [apiclient] Created API client, waiting for the control plane to become ready
# [apiclient] All control plane components are healthy after 32.501217 seconds
# 
# 提示：可用`vagrant ssh`登入虚拟机，用`docker events`看看这货在干啥。

_docker_pull(){
  fn_run sudo docker pull registry.cn-hangzhou.aliyuncs.com/google-containers/$1
}

# ref:
#   https://kubernetes.io/docs/admin/kubeadm/ 
#   Running kubeadm without an internet connection

_docker_pull "kube-apiserver-amd64:v1.7.2"
_docker_pull "kube-controller-manager-amd64:v1.7.2"
_docker_pull "kube-scheduler-amd64:v1.7.2"
_docker_pull "kube-proxy-amd64:v1.7.2"
_docker_pull "etcd-amd64:3.0.17"
_docker_pull "pause-amd64:3.0"
_docker_pull "k8s-dns-sidecar-amd64:1.14.4"
_docker_pull "k8s-dns-kube-dns-amd64:1.14.4"
_docker_pull "k8s-dns-dnsmasq-nanny-amd64:1.14.4"