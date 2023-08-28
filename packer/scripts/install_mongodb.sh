#!/bin/sh

apt-get update -y && apt-get install mongodb -y
[ -e /usr/bin/mongo ] && systemctl enable mongodb
systemctl start mongodb
systemctl status mongodb
