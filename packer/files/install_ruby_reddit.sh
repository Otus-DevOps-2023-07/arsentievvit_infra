#!/bin/sh
apt-get update -y && \
apt-get install -y git ruby-full ruby-bundler build-essential
git clone -b monolith https://github.com/express42/reddit.git /home/ubuntu/reddit
cd /home/ubuntu/reddit && bundle install
