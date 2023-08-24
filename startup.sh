#!/bin/sh
sudo apt update -y && \
sudo apt install -y git mongodb ruby-full ruby-bundler build-essential

[ -e /usr/bin/mongo ] && sudo systemctl enable mongodb
sudo systemctl start mongodb

git clone -b monolith https://github.com/express42/reddit.git /home/yc-user/redditapp && \
cd /home/yc-user/redditapp
chown -R yc-user:yc-user /home/yc-user
[ -e /usr/bin/bundle ] && bundle install
su - yc-user -c "cd redditapp;puma -d"
sleep 10
IP=`curl 2ip.ru`
PORT=`ps aux | grep puma | grep -v grep | sed -n 's/.*:\([0-9]\+\).*/\1/p'`
echo "$IP:$PORT" > /home/yc-user/connect.txt
