#
# Cleanup filesystem for clean disk blocks
#
set -ux

echo '> Cleaning filesystem...'

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync
sync
sync

echo '> Done'

exit 0
