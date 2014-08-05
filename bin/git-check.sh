#!/bin/bash
# encoding: utf-8

ORIG_PS1=$PS1
ORIG_STDIN=$0

pushd ~ >/dev/null

while read -r dirname; do
  pushd "$dirname" >/dev/null
  if [ -d .git ]; then
    printf "\n*** %s ***\n" "$(pwd)"
    git fetch --all --prune --quiet
    if [ -n "$(git status --porcelain)" ]; then
      git status --porcelain
      # The following doesn't work
      #export PS1="Subshell $(pwd)> "
      #/bin/bash -i <$ORIG_STDIN
    fi
  fi
  popd >/dev/null
done < <(find . -type d -name .git \! -path './.rbenv*' -exec dirname {} \; 2>/dev/null)

export PS1=$ORIG_PS1
popd >/dev/null
