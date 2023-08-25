#!/bin/sh

sudo apt update -y && sudo apt install mongodb -y
[ -e /usr/bin/mongo ] && sudo systemctl enable mongodb
sudo systemctl start mongodb
sudo systemctl status mongodb
