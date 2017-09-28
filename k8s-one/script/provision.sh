#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# ls script/ | grep provision_ | sed -e "s/^.*$/\/vagrant\/script\/\0/g"
/vagrant/script/provision_01_before.sh
/vagrant/script/provision_02_yum_mirror.sh
/vagrant/script/provision_03_init_env.sh
/vagrant/script/provision_04_install_docker.sh
/vagrant/script/provision_05_pull_images.sh
/vagrant/script/provision_06_install_kube.sh
/vagrant/script/provision_07_install_kube_components.sh
