#!/bin/bash

cd $(dirname $0)

sudo service myexample stop
sudo systemctl disable myexample.service > /dev/null 2>&1

sudo rm /etc/init.d/myexample
sudo rm /etc/systemd/system/myexample.service

sudo systemctl daemon-reload
