#!/bin/bash

get_current_variables() {
  MY_UID=$(stat -c %u ${MOUNTED_DIR})
  MY_GID=$(stat -c %g ${MOUNTED_DIR})
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
  getent group ${DOCKER_GID} || addgroup --gid ${DOCKER_GID} host_docker
  if [ -e "/usr/local/ruby/bin/bundle" ]; then
    getent group ${RUBY_GID} || addgroup --gid ${RUBY_GID} ruby
  fi
  adduser --home /usr/local/home/${USERNAME} --uid ${MY_UID} --gid ${MY_GID} --gecos '' --disabled-password ${USERNAME}
  getent group docker && usermod -a -G docker ${USERNAME} ||:
  getent group host_docker && usermod -a -G host_docker ${USERNAME} ||:
  getent group ruby && usermod -a -G ruby ${USERNAME} ||:
}

configure_homedir() {
  # Link in some needed dirs and do some chowning
  ls -al /usr/local/home/nitrous
  for filename in git dius .ssh; do
    if [ -e ${MOUNTED_DIR}/$filename ]; then
      ln -s ${MOUNTED_DIR}/$filename ~${USERNAME}/$filename
    fi
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
