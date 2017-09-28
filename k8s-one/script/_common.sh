#!/bin/bash

##################
# init
##################

_common_trap_error(){
  fn_trap_on_err
}
trap _common_trap_error ERR


##################
# common func
##################

fn_trap_on_err() {
  fn_error "traped an error: ↑ , trace: ↓"
  fn_stack
}
fn_error(){
  echo -e "ERROR - $*" >&2
}
fn_info(){
  echo -e "INFO  - $*" >&1
}
fn_stack () {
  local i=0
  local errout
   while true
   do
      errout=$(caller $i 2>&1 && true) && true
      if [[ $? != 0 ]]; then break ; fi
      echo "  $errout" >&2
      i=$((i+1))
   done
}
fn_run(){
  fn_info "▶︎ ◼︎ $*"
  eval "$*"
}
