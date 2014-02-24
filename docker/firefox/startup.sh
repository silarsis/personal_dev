#!/bin/bash

sudo /etc/init.d/xdm start
x11vnc -forever -create -nopw -noxdamage -ncache 10 -ncache_cr