### env
```shell
# add share lib search
# option1 for tmp 
LD_LIBRARY_PATH=/opt/pgsql/lib
export LD_LIBRARY_PATH
# option2 for persistent
echo "/opt/pgsql/lib" >> /etc/ld.so.conf.d/pgsql.conf
ldconfig


# add env and man path
# option1 for tmp
PATH=/usr/local/pgsql/bin:$PATH
export PATH
MANPATH=/usr/local/pgsql/share/man:$MANPATH
export MANPATH
# option2 for persistent
echo "PATH=/usr/local/pgsql/bin:$PATH" >> ~/.bashrc
source ~/.bashrc


tee > customer.env << "EOF"
APP_NAME=myapp
APP_PORT=8080
EOF
# local variable still valid in current shell: source and .
. customer.env
source customer.env
echo $APP_NAME


```

### exec
```shell
# executed command and exit current shell(process replacement)
echo $$
exec sleep 100
ps -ef |grep sleep # in another terminal tab


# replace current shell session
exec zsh


# program calls with exec in bash scripts
tee test.sh << "EOF"
#!/bin/bash
while true
do
        echo "1. Update "
        echo "2. Upgrade "
        echo "3. Exit"
   read Input
   case "$Input" in
        1) exec sudo apt update ;;
        2) exec sudo apt upgrade  ;;
        3) break
   esac
done
EOF


### Linux file descriptors
stdin (0) - Standard in
stdout (1) - Standard out
stderr (2) - Standard error
###
# open file descriptor with read mode
exec 9</tmp/t.log
# open file descriptor with write mode 
exec 9>/tmp/t.log
# open file descriptor with read and write mode 
exec 9<>/tmp/t.log
# close file desciptor
exec 9>&-
###
# operate file descriptors redirect stdin/stdout/stderr
tee > test.sh << "EOF"
exec 1> /tmp/console.log
#exec 1>> /tmp/console.log
exec 2>&1
echo "This is stdin line"
eho "This line has an error and is logged as stderr"
EOF
./test.sh && cat /tmp/consile.log
# custom file descriptors
tee > test.sh << "EOF"
echo "Open file descriptor 3(overwrite mode)"
exec 3> 3.log
echo "Open file descriptor 4(append mode)"
exec 4>> 4.log
echo "Open file descriptor 5, redirect to file descriptor 3"
exec 5>& 3
echo "sending some data..."
echo "exec test 333" 1 >& 3
echo "exec test 444" 1 >& 4
echo "exec test 555" 1 >& 5
echo "Closing fd 3..."
exec 3>&-
echo "Closing fd 4..."
exec 4>&-
echo "Closing fd 5..."
exec 5>&-
EOF


# run scripts in a clean environment
exec -c printenv
# exec with find command
find /tmp/ -name "test.log" -exec chmod +x '{}' \;



```

### function 
```shell
# script position 
tee > test.sh << "EOF"
#/usr/bin/env bash
echo "Length of argument: $#"
echo "Values of argument(args as one world): $@"
echo "Values of argument(args list): $@"
EOF
./test.sh a b c
# foreach arguments list
${[*]}  
${[@]}


# define local variable
# option1: use local
fuction test() {
    local my_key=my_value
    echo $my_key
}
# option2: use (), function will be executed in chirl process
function test() (
    my_key=my_value
    echo $my_key
)

```

### set 
```shell
# set to environment variable
set -a testk
set -o allexport

# exit the shell script if returned by the command is not equal 0
set -e
set -o errexit
# return the value of pipline rightmost command if it non-zero status 
set -o pipefail

# cancle to use wildcards
set -f 
set -o noglob

# monitor mode
set -m
set -o monitor

# only reads instructions without actually executing them
set -n
set -o noexec

# exit after reading and executing one command.
set -t
set -o onecmd

# display error if variable not exists
set -u
set -o nounset

# display parameters after executing command
set -x
set -o xtrace



```

### print
```shell
# format 
df -h |column -t

df -h | awk '{printf "%-20s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6}'
```

### truncate string
```shell
# truncate string
variable="Hello World"
echo "${variable#He}"   # output: llo World
echo "${variable%ld}"   # output: Hello Wor
echo "${variable:3:5}"  # output: lo Wo
echo "${variable#*o}"   # output: rld
echo "${#variable}"     # length
variable="path/to/some/file.txt"
result="${variable##*/}"   # longest match from start, get: file.txt
variable="path/to/some/file.txt"
result="${variable%%/*}"   # longest match from end, get: path

```

### template.sh
```shell
#!/bin/bash

# help info
### template.sh -— call xxx command to do something
###
### Usage:
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
###   # Do event 1
###   ./template.sh aaa bbb
###   # Do event 2
###   ./template.sh xxx yyy
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
```


>Reference:
> 1. [Shell command official manual](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
> 2. [关于 Bash 的 10 个常见误解](https://xie.infoq.cn/article/247481c8dc6dc4607c1d7515e)
