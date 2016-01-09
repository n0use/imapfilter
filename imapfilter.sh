#!/bin/sh
# make sure imapfilter is started - 
# run script out of .profile, requires imapfilter.lua config
#
# John Newman jnn@synfin.org 06/02/15
#
# this script can ALSO be used to restart imapfilter (to reload changed config
# or if you've changed your password) - use the flag "restart"
#


user=$(whoami)
pid=$(ps -U $user -o pid,args | awk '$2 ~ /^[^ ]*imapfilter$/ { print $1 }')
log="/home/$user/var/log/imapfilter.log"

if [ "$1" = "restart" ] ; then
    shift
    echo "Restarting - killing current imapfilter [pid=$pid]"
    kill $pid &> /dev/null
    pid=""
    sleep 1
fi

if [ "$1" = "-v" ]  ; then 
    verbose=1
    args="-l $log -d ${log}.debug -v"
else
    args="-l $log"
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
