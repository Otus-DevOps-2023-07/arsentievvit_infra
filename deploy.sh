#!/bin/sh

sudo apt update -y && sudo apt install git -y
git clone -b monolith https://github.com/express42/reddit.git ~/redditapp && cd ~/redditapp
[ -e /usr/bin/bundle ] && bundle reddit
puma -d
IP=`curl 2ip.ru`
PORT=`ps aux | grep puma | grep -v grep | sed -n 's/.*:\([0-9]\+\).*/\1/p'`
echo "You can connect to the app using:"
echo "$IP:$PORT" | tee ~/connect.txt
