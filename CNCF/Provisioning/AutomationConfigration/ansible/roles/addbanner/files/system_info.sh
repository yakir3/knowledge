#!/bin/bash

#Bash Colour Codes
red="\033[00;31m"
RED="\033[01;31m"
green="\033[00;32m"
GREEN="\033[01;32m"
brown="\033[00;33m"
YELLOW="\033[01;33m"
blue="\033[00;34m"
BLUE="\033[01;34m"
magenta="\033[00;35m"
MAGENTA="\033[01;35m"
cyan="\033[00;36m"
CYAN="\033[01;36m"
white="\033[00;37m"
WHITE="\033[01;37m"

date=`date "+%F %T"`
head="当前时间 : $date"
 
kernel=`uname -r`
hostname=`echo $HOSTNAME`
 
#Cpu load
load1=`cat /proc/loadavg | awk '{print $1}'`
load5=`cat /proc/loadavg | awk '{print $2}'`
load15=`cat /proc/loadavg | awk '{print $3}'`
 
#System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))
up_lastime=`date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S"`
 
#Memory Usage
#mem_usage=`free -m | awk '/Mem:/{total=$2} /buffers\/cache/ {used=$3} END {printf("%3.2f%%",used/total*100)}'`
mem_usage=`free | grep Mem | awk '{printf "%.2f%", $3/$2*100}'`
swap_usage=`free | awk '/Swap/{printf "%.2f%",$3/$2*100}'`
 
#Processes
processes=`ps aux | wc -l`
 
#User
users=`users | wc -w`
USER=`whoami`
 
#last login
if [ "$(id -u)" == "0" ]; then
    lastuser=`last -1 |grep -v wtmp |awk '{print $1}'`
    lastip=`last -1 |grep -v wtmp |awk '{print $3}'`
fi

#System fs usage
Filesystem=$(df -Ph | awk '/^\/dev/{print $6"."$5}')
 
#Interfaces
INTERFACES=$(`which ip` -4 ad | grep 'state ' | awk -F":" '!/^[0-9]*: ?lo/ {print $2}')

#sort cpu usage
CPU_USAGE=`ps aux|head -1;ps aux|grep -v PID|sort -rn -k +3|head |awk '{print "用户: " $1 " 进程号: " $2 "  使用率:  " $3  " 命令: " $11 }'`
 
echo
echo -e "${magenta}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "${brown} $head"
echo -e "${magenta}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
printf "${GREEN} 内核版本:\t\t%s\n" $kernel
printf "${YELLOW} 主机名:\t\t%s\n" $hostname
printf "${BLUE} 运行时间:\t\t%s "days" %s "hours" %s "min" %s "sec"\n" $upDays $upHours $upMins $upSecs
printf "${cyan} 当前登录用户数:\t%s\n" $users 
printf "${cyan} 当前用户:\t\t%s\n"  $USER
if [ "$(id -u)" == "0" ]; then
    printf "${blue} 最后登录用户:\t\t%s\n" $lastuser
    printf "${blue} 最后登录IP:\t\t%s\n" $lastip
fi 
printf "${MAGENTA} 总进程数:\t\t%s\n" $processes
printf "${green} 系统负载:\t\t%s %s %s\n" $load1, $load5, $load15
printf "${brown} 内存使用:\t\t%s\n" $mem_usage 
printf "${brown} Swap使用:\t\t%s\n" $swap_usage
printf "${CYAN} 系统挂载点\t使用情况\n"
for f in $Filesystem
do
     echo -e "\t" $f |awk -F '.' '{print $1 "\t" $2}' 
done

printf "${MAGENTA}CPU使用前3进程:\n" 
 ps -Ao pcpu,comm,pid,user,etime,pmem,lstart --sort=-pcpu | head -n 4

printf "${YELLOW}内存使用前3进程:\n" 
ps -eo pmem,comm,pid,rss,vsz,user --sort -rss |awk 'NR>1 {$4=int($4/1024)"M";$5=int($5/1024)"M";}{ print;}'|column -t |head -n 4

printf "${red}网络接口\tMAC地址\t\tIP地址\n"
for i in $INTERFACES
do
    MAC=$(`which ip` ad show dev $i | grep "link/ether" | awk '{print $2}')
    IP=$(`which ip` ad show dev $i | awk '/inet / {print $2}')
    printf "  "$i"\t"$MAC"\t$IP\n"
done
echo
echo -e "${RED}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "${RED}  WARNNING ! This Is A Production Server,Be Careful What You Will Do !"
echo -e "${RED}++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo

#Sets No Colour
NC="\033[00m"
echo -e "${NC}"
