#!/bin/bash

USERNAME="silarsis"

get_current_variables() {
  MY_UID=$(stat -c %u /Users/${USERNAME})
  MY_GID=$(stat -c %g /Users/${USERNAME})
  MY_UMASK=$(umask)
  DOCKER_GID=$(stat -c %g /var/run/docker.sock)
  if [ -e "/usr/local/ruby/bin/bundle" ]; then
    RUBY_GID=$(stat -c %g /usr/local/ruby/bin/bundle)
  fi
}

delete_clashes() {
  # Delete all in the container that matches uid or gid to external resources
  getent group ${MY_GID} | cut -d: -f1 | xargs --no-run-if-empty groupdel
  getent group ${DOCKER_GID} | cut -d: -f1 | xargs --no-run-if-empty groupdel
  if [ -e "/usr/local/ruby/bin/bundle" ]; then
    getent group ${RUBY_GID} | cut -d: -f1 | xargs --no-run-if-empty groupdel
  fi
}

add_user_and_groups() {
  addgroup --gid ${MY_GID} ${USERNAME}
  addgroup --gid ${DOCKER_GID} host_docker
  if [ -e "/usr/local/ruby/bin/bundle" ]; then
    addgroup --gid ${RUBY_GID} ruby
  fi
  adduser --uid ${MY_UID} --gid ${MY_GID} --gecos '' --disabled-password ${USERNAME}
  usermod -a -G docker,host_docker ${USERNAME}
  if [ -e "/usr/local/ruby/bin/bundle" ]; then
    usermod -a -G ruby ${USERNAME}
  fi
}

configure_homedir() {
  # Link in some needed dirs and do some chowning
  for filename in git dius .ssh; do
    [ -e /Users/${USERNAME}/$filename ] && ln -s /Users/${USERNAME}/$filename /home/${USERNAME}/$filename
  done
}

set -e
set -x

get_current_variables
umask 0133
delete_clashes
add_user_and_groups
configure_homedir
umask ${MY_UMASK}

# Pass things over to user land
set +e
set +x
su -l ${USERNAME}
