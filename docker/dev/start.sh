#!/bin/bash

set +x

# There's a big dance here to change the user UID and GID to match that
# of the mounted filesystem.

OLD_UID=`id -u silarsis`
OLD_GID=`id -g silarsis`
MY_UID=`stat -c %u /home/silarsis/share/.bashrc`
MY_GID=`stat -c %g /home/silarsis/share/.bashrc`
MY_UMASK=`umask`
umask 0133
grep -v silarsis /etc/passwd > /tmp/passwd && mv /tmp/passwd /etc/passwd
grep -v silarsis /etc/group > /tmp/group && mv /tmp/group /etc/group
# There may be some arbitrary files that clash here (dialout group owned)
grep -v ":${MY_GID}:" /etc/group > /tmp/group && mv /tmp/group /etc/group
echo "silarsis:x:${MY_UID}:${MY_GID}:,,,:/home/silarsis:/bin/bash" >> /etc/passwd
echo "silarsis:x:${MY_GID}:" >> /etc/group
cd /home/silarsis
find . -xdev -uid ${OLD_UID} | xargs chown silarsis
find . -xdev -gid ${OLD_GID} | xargs chgrp silarsis
umask ${MY_UMASK}
su -l silarsis
