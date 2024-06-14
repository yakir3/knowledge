#!/bin/bash

# Help info
### Script function description
###
### Usage:
###   ./template.sh [command]
###   ./template.sh <arg1> <arg2> [option1]
###
### Options:
###   <arg1>       arg1: xxx
###   <arg2>       arg2: xxx
###   [option1]    option1: xxx
###
### Examples:
###   # Show this message
###   ./template.sh -h
###
###   # Do event 1
###   ./template.sh aaa bbb
###
###   # Do event 2
###   ./template.sh xxx yyy
###
###   # Do event 3
###   ./template.sh arg1 arg2 option1
function help_info() {
  sed -rn 's/^### ?//;T;p;' "$0"
  exit 1
}

# logging
function log_info() {
  local message="$@"
  echo "[INFO] $message"
}
function log_warning() {
  local message="$@"
  echo "[WARNING] $message" >&2
}
function die_exit() {
  local message="$@"
  echo "[ERROR] $message" 1>&2
  exit 111
}


# global environment
key1=value1
timeout=120s


# main function
function main() {
    # help info
    [[ $# -lt 2 ]] || [[ $1 == "-h" ]] && help_info
}

main "$@"
