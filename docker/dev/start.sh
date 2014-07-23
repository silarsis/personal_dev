#!/bin/bash

set +x

# There's a big dance here to change the user UID and GID to match that
# of the mounted filesystem.

OLD_UID=`id -u silarsis`
OLD_GID=`id -g silarsis`
MY_UID=`stat -c %u /Users/silarsis/.bashrc`
MY_GID=`stat -c %g /Users/silarsis/.bashrc`
MY_UMASK=`umask`
umask 0133
grep -v silarsis /etc/passwd > /tmp/passwd && mv /tmp/passwd /etc/passwd
grep -v silarsis /etc/group > /tmp/group && mv /tmp/group /etc/group
# There may be some arbitrary files that clash here (dialout group owned)
grep -v ":${MY_GID}:" /etc/group > /tmp/group && mv /tmp/group /etc/group
echo "silarsis:x:${MY_UID}:${MY_GID}:,,,:/home/silarsis:/bin/bash" >> /etc/passwd
echo "silarsis:x:${MY_GID}:" >> /etc/group
cd /home/silarsis
ln -s /Users/silarsis/git /home/silarsis/git
ln -s /Users/silarsis/dius /home/silarsis/dius
find . -xdev -print0 -uid ${OLD_UID} | xargs -0 chown silarsis
find . -xdev -print0 -gid ${OLD_GID} | xargs -0 chgrp silarsis
umask ${MY_UMASK}
[[ "$@" == "/bin/sh -c /bin/bash" ]] && CMD="" || CMD="$@"
exec su -l -s /usr/local/bin/user_start.sh silarsis ${CMD}
