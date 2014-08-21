#!/bin/bash

export AWS_CLI=/usr/local/bin/aws
export AWS_REGION=ap-southeast-2
export AWS_USER=kevin.littlejohn
export STACK_NAME=kevinl
export IDP_HOST=idp.realestate.com.au

eval $(ssh-agent -s -a /tmp/ssh-agent.sock)
tmux
