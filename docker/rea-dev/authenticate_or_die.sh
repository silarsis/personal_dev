#!/bin/bash

authenticate
[ -z "$AWS_ACCESS_KEY_ID" ] && exit 1
export PS1="$AWS_ROLE> "
alias aws='aws_saml $@'
