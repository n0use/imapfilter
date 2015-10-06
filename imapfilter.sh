#!/bin/sh
# make sure imapfilter is started - 
# run script out of .profile/.bashrc/.cshrc/whatever 
# requires ~/.imapfilter/config.lua imapfilter configuration
# all code written to run on FreeBSD 10.x - easily adaptable to any other *nix
#
# John Newman jnn@synfin.org 09/15

user=$(whoami)
pid=$(ps -U $user -o pid,args | awk '$2 ~ /^[^ ]*imapfilter$/ { print $1 }')
log="/home/$user/var/log/imapfilter.log"

if [ "$1" = "-v" ]  ; then 
    verbose=1
    args="-l $log -d ${log}.debug -v"
    shift
else
    args="-l $log"
fi

if [ "$1" = "restart" ] ; then
    echo "Restarting imapfilter - killing pid [$pid]"
    kill $pid
    echo -n ".."
    sleep 3
    kill -9 $pid
    pid=$(ps -U $user -o pid,args | awk '$2 ~ /^[^ ]*imapfilter$/ { print $1 }')
    if [ -n "$pid" ] ; then
        echo "Cannot kill! imapfilter (pid = $pid) still running."
        echo "Aborting"
        exit 1
    fi
    pid=""
fi

if [ -z "$pid" ] ; then 
    /usr/local/bin/imapfilter $args 
    ret=$?
else 
    msg="imapfilter already running [pid = $pid]"
    [ "$verbose" = "1" ] && echo "$(date): $msg"
    echo "$(date): $msg" >> $log
    exit 1
fi
exit $ret
