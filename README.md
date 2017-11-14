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
$ bash $PINGERBELL_HOME/pingerbell.sh target.list
or
$ cd $PINGERBELL_HOME ; bash pingerbell.sh target.list
```

It could occur errors from slack.  
You can set  your Slack information on `pingerbell.sh`.

## How to configure 

`pingerbell.sh` is editorable.

```shell
#
# slack configure
#
slack_webhook='https://hooks.slack.com/services/123456789/123456789/XXXXXXXXXXXXXXXXXXX'
slack_channel='pingmonitor'
slack_username=$(hostname)
slack_title='[Pingerbell of YOUR_PROJECT]'

#
# PINGERBELL configure
#
ping_timeout="2"
ping_count="1"
```


## Set crontab

In case of monitoring every minutes, Add `/etc/cron.d/pingerbell`.

```shell
* * * * * root /bin/bash /path/to/pingerbell.sh target.list
```

You can use several lists as below.

```shell
* * * * * root /bin/bash /path/to/pingerbell.sh target.list
* * * * * root /bin/bash /path/to/pingerbell.sh production.list
* * * * * root /bin/bash /path/to/pingerbell.sh target.d/stage.list
```

You will get messages from Slack when your server isn't responsible.  


Enjoy it!
