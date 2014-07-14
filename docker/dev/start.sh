#!/bin/bash

groupadd -o -g `stat -c %g /home/silarsis` silarsis
useradd silarsis -u `stat -c %u /home/silarsis` -g silarsis -G rvm
cd /home/silarsis
sudo -E -H -s -u silarsis /bin/bash --rcfile /opt/dev/bashrc
