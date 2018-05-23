#!/bin/bash
#-------------------------------------------------
# Title : pingerbell
# Author : santa(itvans@gmail)
# Description : Check the server with ping
#-------------------------------------------------
PINGERBELL_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $PINGERBELL_HOME/pingerbell.conf

#
# PINGERBELL configure
#
ping_timeout=$ping_timeout
ping_count=$ping_count
targets="$PINGERBELL_HOME/$1"
log_path="$PINGERBELL_HOME/result.log"
errorlog_path="$PINGERBELL_HOME/error.log"
delimiter=":"

#
# init pingerbell log
#
cat /dev/null > $log_path
cat /dev/null > $errorlog_path

#
# Main script
#
declare -a target_arr
let i=0
while IFS=$'\n' read -r array_element; do
    # add element in array from file 
    target_arr[i]="${array_element}" 
    echo ${target_arr[i]}

    # distingish data
    echo ${target_arr[i]} | grep "${delimiter}" > /dev/null
    if [ $? == 0 ]; then
        echo "# checking port" 
        # Make it check port
        echo ping | nc -w 3 $(echo ${target_arr[i]} | awk '{print $1}' |sed  s/${delimiter}/' '/g )
    else 
        echo "# checking ping" 
        # Make it check ping
        ping  $(echo ${target_arr[i]} | awk '{print $1}') -c $ping_count -W $ping_timeout
    fi

    # print result 
    rst_code=$?
    echo "Result Code: $rst_code from ${target_arr[i]}" | tee -a ${log_path}

    # increase a value
    ((++i))

done < $targets

# get error
grep -v 'Result Code: 0' ${log_path} > $errorlog_path
if [ $(wc -l $errorlog_path | awk '{print $1}') != 0 ]; then
    echo "it will be sent soon"
    curl -X POST --data-urlencode "payload={ \"channel\": \"#$slack_channel\", \"username\": \"$slack_username\", \"text\": \"*$slack_title*\n$(cat $errorlog_path)\", \"icon_emoji\": \":ghost:\"}" $slack_webhook
else 
    echo "it makes all normal"
fi

