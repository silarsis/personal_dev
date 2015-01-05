#!/bin/bash

configure_git() {
  git config --global color.ui auto \
  && git config --global user.email "kevin@littlejohn.id.au" \
  && git config --global user.name "Kevin Littlejohn" \
  && git config --global push.default simple
}

trap /bin/true INT

export AWS_CLI=/usr/local/bin/aws
export AWS_REGION=ap-southeast-2
export AWS_USER=kevin.littlejohn
export STACK_NAME=kevinl
export IDP_HOST=idp.realestate.com.au
export IDP_USER=${AWS_USER}

# Ruby
export PATH=$PATH:/usr/local/ruby/bin
export GEM_HOME=/usr/local/ruby/lib/ruby/gems/2.1.0
export GEM_PATH=/usr/local/ruby/lib/ruby/gems/2.1.0

/usr/local/ruby/bin/bundle config --global jobs 4

eval $(ssh-agent -s -a /tmp/ssh-agent.sock)
[ -d ~/.ssh/auto ] && ssh-add ~/.ssh/auto/*
configure_git
exec bash
