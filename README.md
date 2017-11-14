# Pingerbell 


Pingerbell *ping* your servers with `nc`.

It gives as below :
- easy to set up 
- simple to use
- alerts to [Slack](https://slack.com)

## Requirement

- Only `nc`
- Slack (optinal)


## Installation

```shell
$ yum -y install nc
$ git clone https://github.com/lq84129/pingerbell.git 
```

## Set target address

Edit `$PINGERBELL_HOME`/`target.list` for what you need to monitor.

You can only set `IP` or `IP:Port`.
Now, It is not possible to set with `#` as comment

```shell
127.0.0.1 
127.0.0.1:65432 
```

## Run Pingerbell

```shell
$ bash $PINGERBELL_HOME/pingerbell.sh
or
$ cd $PINGERBELL_HOME ; bash pingerbell.sh
```

It could occur errors from slack.  
You can set  your Slack information on `pingerbell.sh`.

## How to configure 

`pingerbell.sh` is editorable.

```shell
#
# configure
#
targets="$DIR/target.list"	# location of target file 
timeout="2"     			# ping timeout
count="1"					# ping count 
log_path="$DIR/result.log"	# log 
errorlog_path="$DIR/error.log" # Only Errorlogs
delimiter=":"				# Don't modify!!! (it will be moved to Main Script on next commit)

#
# slack configure
#
slack_webhook='https://hooks.slack.com/services/123456789/123456789/XXXXXXXXXXXXXXXXXXX' # Slack webhook address
slack_channel='YOUR CHANNEL'				# Slack Channel name
slack_username=$(hostname) 					# or username that you want
slack_title='[Pingerbell of YOUR_PROJECT]' 	# Set text as first line
```


## Set crontab

In case of monitoring every minutes, Add `/etc/cron.d/pingerbell`.

```shell
* * * * * root /bin/bash /path/to/pingerbell.sh
```

You will get messages from Slack when your server isn't responsible.  


Enjoy it!
