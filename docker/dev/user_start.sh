#!/bin/bash

trap /bin/true INT

export AWS_CLI=/usr/local/bin/aws
export AWS_REGION=ap-southeast-2
export AWS_USER=kevin.littlejohn
export STACK_NAME=kevinl
export IDP_HOST=idp.realestate.com.au
export IDP_USER=${AWS_USER}
export PATH=$PATH:/usr/local/ruby/bin
export GEM_HOME=/usr/local/ruby

/usr/local/ruby/bin/bundle config --global jobs 4

eval $(ssh-agent -s -a /tmp/ssh-agent.sock)
[ -d ~/.ssh/auto ] && ssh-add ~/.ssh/auto/*
exec tmux
