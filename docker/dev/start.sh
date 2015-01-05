#!/bin/bash

get_current_variables() {
  MY_UID=$(stat -c %u /Users/silarsis/.bashrc)
  MY_GID=$(stat -c %g /Users/silarsis/.bashrc)
  MY_UMASK=$(umask)
  DOCKER_GID=$(stat -c %g /var/run/docker.sock)
  RUBY_GID=$(stat -c %g /usr/local/ruby/bin/bundle)
}

delete_clashes() {
  # Delete all in the container that matches uid or gid to external resources
  getent group ${MY_GID} | cut -d: -f1 | xargs --no-run-if-empty groupdel
  getent group ${DOCKER_GID} | cut -d: -f1 | xargs --no-run-if-empty groupdel
  getent group ${RUBY_GID} | cut -d: -f1 | xargs --no-run-if-empty groupdel
}

add_user_and_groups() {
  addgroup --gid ${MY_GID} silarsis
  addgroup --gid ${DOCKER_GID} host_docker
  addgroup --gid ${RUBY_GID} ruby
  adduser --uid ${MY_UID} --gid ${MY_GID} --gecos '' --disabled-password silarsis
  echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
  usermod -a -G docker,host_docker,ruby silarsis
}

configure_homedir() {
  cd /home/silarsis
  # Link in some needed dirs and do some chowning
  ln -s /Users/silarsis/git /home/silarsis/git
  ln -s /Users/silarsis/dius /home/silarsis/dius
  ln -s /Users/silarsis/.ssh /home/silarsis/.ssh
  cp /usr/local/src/bash_profile /home/silarsis/.bash_profile && chown silarsis.silarsis /home/silarsis/.bash_profile
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
exec su -l -s /usr/local/bin/user_start.sh silarsis
