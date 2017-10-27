#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# fn_run sudo rsync --compress --recursive --verbose --human-readable  $proj_home/provision/ /

# 配置bash环境
cat <<-'EOF'>>/home/vagrant/.bashrc
cd /vagrant
EOF

