#!/bin/bash

set +x
echo "1"

#groupadd -o -g `stat -c %g /home/silarsis` silarsis
#useradd silarsis -u `stat -c %u /home/silarsis` -g silarsis -G rvm
usermod -u `stat -c %u /home/silarsis/.bashrc` silarsis
echo "2"
usermod -g `stat -c %g /home/silarsis/.bashrc` silarsis
echo "3"
cd /home/silarsis
echo "4"
sudo -E -H -s -u silarsis /bin/bash --rcfile /opt/dev/bashrc
