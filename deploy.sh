#!/bin/bash

sudo apt update -y && sudo apt install git -y
git clone -b monolith https://github.com/express42/reddit.git
cd ~/reddit
[ -e /usr/bin/bundle ] && bundle install
puma -d
