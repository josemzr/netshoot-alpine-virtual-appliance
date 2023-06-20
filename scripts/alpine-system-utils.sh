#!/bin/bash -eux

##
## Debian system
## Install system utilities
##

echo '> Installing System Utilities...'

apk add --no-cache \
  jq \
  git \
  vim \
  tmux \
  htop \
  unzip

echo '> Done'
