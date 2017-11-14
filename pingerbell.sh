#!/bin/bash
#-------------------------------------------------
# Title : pingerbell
# Author : santa(itvans@gmail)
# Description : Check the server with ping
#-------------------------------------------------
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
# configure
#
targets="$DIR/target.list"
timeout="2"
count="1"
log_path="$DIR/result.log"
errorlog_path="$DIR/error.log"
delimiter=":"

#
# slack configure
#
slack_webhook='https://hooks.slack.com/services/123456789/123456789/XXXXXXXXXXXXXXXXXXX'
slack_channel='ping-kr'
slack_username=$(hostname)
slack_title='[Pingerbell of YOUR_PROJECT]'

#
# init pingerbell log
#
cat /dev/null > $log_path
cat /dev/null > $errorlog_path

#
# Main script
#
declare -a myarray
let i=0
while IFS=$'\n' read -r array_element; do
    # add element in array from file 
    myarray[i]="${array_element}" 
    echo ${myarray[i]}

    # distingish data
    echo ${myarray[i]} | grep "${delimiter}" > /dev/null
    if [ $? == 0 ]; then
        echo "# checking port" 
        # Make it check port
        echo ping | nc $(echo ${myarray[i]} |sed  s/${delimiter}/' '/g )
    else 
        echo "# checking ping" 
        # Make it check ping
        ping ${myarray[i]} -c $count -W $timeout

    fi

    # print result 
    rst_code=$?
    echo "Result Code: $rst_code from ${myarray[i]}" | tee -a ${log_path}

    # increase a value
    ((++i))

done < $targets

# get error
grep -v 'Result Code: 0' ${log_path} > $errorlog_path
if [ $(wc -l $errorlog_path | awk '{print $1}') != 0 ]; then
    echo "it will be sent soon"
    curl -X POST --data-urlencode "payload={ \"channel\": \"#$slack_channel\", \"username\": \"webhookbot\", \"text\": \"*$slack_title*\n$(cat $errorlog_path)\", \"icon_emoji\": \":ghost:\"}" $slack_webhook
else 
    echo "it makes all normal"
fi

