#!/bin/bash -eux

##
## Alpine
## Setup ResizeFS script
##

echo '> Setup ResizeFS boot script...'

chmod +x /opt/alpine-resizefs.sh
echo "@reboot root  /opt/alpine-resizefs.sh" >> /var/spool/cron/crontabs
