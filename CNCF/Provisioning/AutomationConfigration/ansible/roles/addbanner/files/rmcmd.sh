#!/bin/bash

rm_cmd(){

arg_array=()
for var in $*
do
    if [ ! `echo "$var" |grep "^-"` ];then
      arg_array+=("$var")      
    fi 
done 

if [ "$#" -eq "0" ] ;then
    echo -e "\e[00;32mYou Are Using Security \"rm\" command \e[00m"
    return 0
elif [ ${#arg_array[@]} -eq 0 ];then
    echo -e "\e[00;32mYou Are Using Security \"rm\" command \e[00m"
    return 0
fi

echo -e "\033[00;31mYou are going to DELETE:  \033[00m"

list_array=()
for element in ${arg_array[@]}
do
   if [ -f $element ];then
       echo FILE: $element 
       list_array+=("$element")
   elif [ -d $element ];then 
       echo DIR: $element 
       list_array+=("$element")
   elif [ -S $element ];then 
       echo -e "\e[00;32mSOCKET: $element NOT Allow To Delete\e[00m"
       return 0 
   elif [ -p $element ];then 
       echo -e "\e[00;32mPIPE: $element NOT Allow To Delete\e[00m"
       return 0 
   elif [ -b $element ];then 
       echo -e "\e[00;32mBLOCK DEVICE: $element NOT Allow To Delete\e[00m"
       return 0 
   elif [ -c $element ];then 
       echo -e "\e[00;32mCHARACTER DEVICE: $element NOT Allow To Delete\e[00m"
       return 0 
   else
       echo -e "\e[00;32mNOT Exist: $element \e[00m"
       return 0 
   fi
done

read -n1 -p $'\033[00;31mAre you sure to DELETE [Y/N]? ' answer
case $answer in
Y | y)
      echo -e "\n"

      if [ ! -d "/tmp/.trash/`date -I`" ]; then
        mkdir -p /tmp/.trash/`date -I`
        chown tomcat.tomcat -R /tmp/.trash/
        chmod 777 -R /tmp/.trash/`date -I`
      fi

      for element in ${list_array[@]}
      do 
        echo -e "Deleting $element to /tmp/.trash/`date -I`"
        #/bin/rm --preserve-root	 -rf  $element
        
        mv $element /tmp/.trash/`date -I`

        if [ $? -ne "0" ];then
          echo -e "\nDeleted FAILED"
          return 0
        fi
      done
      echo -e "\nDeleted FINISHED"

      read -n1 -p $'\033[00;31mFree Disk Space ?  [Y/N]? ' fanswer
      case $fanswer in

      Y | y)
          /bin/rm --preserve-root -rf /tmp/.trash/*
          echo -e "\n"
      ;;
      *)
          echo -e "\nFree Disk Space SKIPED"
          echo -e "\n"
      ;;
      esac
;;
*)
      echo -e "\nDelete SKIPED"
;;

esac
#Sets No Colour
NC="\033[00m"
echo -e "${NC}"

}
alias rm='rm_cmd $@'
