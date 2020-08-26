#!/bin/bash

cd $(dirname $0)

sudo ln -s `pwd`/myexample /etc/init.d/myexample
sudo ln -s `pwd`/myexample.service /etc/systemd/system/myexample.service

sudo systemctl daemon-reload
sudo systemctl enable myexample.service > /dev/null 2>&1

sudo service myexample start
