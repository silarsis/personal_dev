#!/bin/bash
#
# Script to run splunk and keep it running

# First, check if we're on a btrfs filesystem - if we are, make sure we have
# a block file to write to

FSTYPE=$(df -T /opt/splunk/var/ | tail -1 | awk '{ print $2 }')
[ "$FSTYPE" == "btrfs" ] && {
  [ -e /opt/splunk-var-blockfile ] || {
    echo 'creating 1Gb data drive for splunk'
    dd if=/dev/zero of=/opt/splunk-var-blockfile bs=1M count=1024
    mkfs.ext4 /opt/splunk-var-blockfile
  }
  mount /opt/splunk-var-blockfile /opt/splunk/var
}
