# vagrant kubernates

## 预备环境

> 因操作系统/工具版本/伟大墙,都可能执行失败，所以尽量固定各种工具版本，这样较保险。
> 安装并启动k8s虚拟机, 公司的网络(上海)，用笔记本需5分钟左右。

安装 virtualbox 5.1 <https://www.virtualbox.org/wiki/Downloads>

安装 vagrantup 2.0 <https://www.vagrantup.com/downloads.html>

我们的vagrant box为[centos/7](https://app.vagrantup.com/centos/boxes/7)，本来vagrant会自动下载基础box,但，好慢啊，

手工从centos网站比较快：

```bash
# 或用某雷下载
wget http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1708_01.VirtualBox.box
vagrant box add --name centos/7 CentOS-7-x86_64-Vagrant-1708_01.VirtualBox.box
```


## 终于可以安装k8s了：

```bash
git clone https://github.com/chen56/kubernetes-vagrant.git
cd kubernetes-vagrant/k8s-one
vagrant up
```

执行成功后，即可使用k8s虚拟机:

```bash
vagrant ssh
kubectl get componentstatuses
```

## 重来一边

```bash
# 删除刚创建的虚拟机
vagrant destroy -f
# 改改再安装一遍
vagrant up
```

## 备忘

### grc.io的国内镜像

`registry.cn-hangzhou.aliyuncs.com/google-containers`

### debug 命令

```bash
vagrant ssh
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart kubelet
kubeadm reset
```

### 故障

如果遇到下面故障，把virtualbox 相应虚拟机手工删除掉，再把项目换个目录重新`vagrant up`。

```bash
==> default: Exporting NFS shared folders...
NFS is reporting that your exports file is invalid. Vagrant does
this check before making any changes to the file. Please correct
the issues below and execute "vagrant reload":

exports:2: path contains non-directory or non-existent components: /Users/cc/git/chen56/env/k8s-one
exports:2: no usable directories in export entry
exports:2: using fallback (marked offline): /
```