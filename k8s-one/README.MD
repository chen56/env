# vagrant kubernates

## 预备环境

1. 安装 virtualbox 5.1 <https://www.virtualbox.org/wiki/Downloads>
1. 安装 vagrantup 2.0 <https://www.vagrantup.com/downloads.html>

因操作系统，工具版本，伟大墙的原因都可能引起脚本失败，所以尽量固定各种工具的版本，比较保险。

目前,我在上海用笔记本执行完需要5分钟。

## 步骤

```bash
git clone https://github.com/chen56/env.git
cd env/k8s-one
vagrant up
```

执行成功后，即可使用k8s虚拟机:

```bash
vagrant ssh
kubectl get componentstatuses
```

## grc.io 加速镜像

registry.cn-hangzhou.aliyuncs.com/google-containers

## debug 命令

```bash
vagrant ssh
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart kubelet
kubeadm reset
```