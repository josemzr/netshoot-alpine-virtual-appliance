#!/bin/bash -eux

##
## Alpine Docker
## Install Docker
##

echo '> Installing Docker...'

# Install Docker from the Community repo
apk add --no-cache docker

# Adding root user to the docker group
addgroup root docker

# Enable Docker system at boot
rc-update add docker default
service docker start

echo '> Done'
