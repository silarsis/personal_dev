#!/bin/bash

set -e
set -x

# There's a big dance here to change the user UID and GID to match that
# of the mounted filesystem.

OLD_UID=$(id -u silarsis)
OLD_GID=$(id -g silarsis)
MY_UID=$(stat -c %u /Users/silarsis/.bashrc)
MY_GID=$(stat -c %g /Users/silarsis/.bashrc)
MY_UMASK=$(umask)
umask 0133
id silarsis 2>/dev/null && userdel silarsis
getent group silarsis >/dev/null && groupdel silarsis
# There may be some arbitrary files that clash here (dialout group owned)
#grep -v ":${MY_GID}:" /etc/group > /tmp/group && mv /tmp/group /etc/group
getent group $MY_GID | cut -d: -f1 | xargs --no-run-if-empty groupdel
echo "silarsis:x:${MY_UID}:${MY_GID}:,,,:/home/silarsis:/bin/bash" >> /etc/passwd
echo "silarsis:x:${MY_GID}:" >> /etc/group
# Delete the group if it exists (boot2docker)
DOCKER_GID=$(stat -c %g /var/run/docker.sock)
getent group $DOCKER_GID | cut -d: -f1 | xargs --no-run-if-empty groupdel
# Add the group and add it to the user
addgroup --gid "$(stat -c %g /var/run/docker.sock)" host_docker
RUBY_GID=$(stat -c %g /usr/local/ruby/bin/bundle)
addgroup --gid $RUBY_GID ruby
usermod -a -G docker,host_docker,ruby silarsis
# Link in some needed dirs and do some chowning
cd /home/silarsis
ln -s /Users/silarsis/git /home/silarsis/git
ln -s /Users/silarsis/dius /home/silarsis/dius
find . -xdev -print0 -uid "${OLD_UID}" | xargs -0 chown silarsis
find . -xdev -print0 -gid "${OLD_GID}" | xargs -0 chgrp silarsis
umask "${MY_UMASK}"
# Pass things over to user land
exec su -l -s /usr/local/bin/user_start.sh silarsis
