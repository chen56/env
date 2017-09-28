#!/bin/bash
set -o errtrace #trap inherited in sub script
set -o errexit
set -o functrace #trap inherited in function
set -o nounset

cmd_path=$(cd `dirname $0`; pwd)
proj_home=$(dirname "$cmd_path")

. ${cmd_path}/_common.sh

# TODO 其他应用组件