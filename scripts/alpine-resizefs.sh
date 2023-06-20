##
## Alpine
## Setup ResizeFS script
##

set -xeu
echo '> Setup ResizeFS boot script...'

chmod +x /opt/alpine-resizefs.sh
echo "@reboot root  /opt/alpine-resizefs.sh" >> /var/spool/cron/crontabs/root
