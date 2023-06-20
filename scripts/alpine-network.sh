##
## Alpine Linux
## Install Network utilities
##

set -xeu 
echo '> Installing Network utilities...'

apk add --no-cache \
  curl \
  rsync \
  busybox-extras \
  mtr

echo '> Done'
