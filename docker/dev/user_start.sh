#!/bin/bash

export AWS_CLI=/usr/local/bin/aws
export AWS_REGION=ap-southeast-2
export AWS_USER=kevin.littlejohn
export STACK_NAME=kevinl
export IDP_HOST=idp.realestate.com.au
export IDP_USER=${AWS_USER}

alias ship='docker run -v $(pwd)/rea-shipper.yml:/app/rea-shipper.yml -e AWS_REGION -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SECURITY_TOKEN rea-shipper'

eval $(ssh-agent -s -a /tmp/ssh-agent.sock)
[ -d ~/.ssh/auto ] && ssh-add ~/.ssh/auto/*
tmux
