#!/bin/bash -eux

##
## Alpine Linux
## Install Network utilities
##


echo '> Installing Network utilities...'

apk add --no-cache -y \
  curl \
  rsync \
  busybox-extras \
  mtr

echo '> Done'
