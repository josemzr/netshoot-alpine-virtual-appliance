##
## Alpine Settings
## Misc configuration
##

set -xeu 
echo '> Alpine Settings...'

echo '> SSH directory'
mkdir -vp $HOME/.ssh

echo '> Adding vimrc'
echo "set mouse-=a" >> /root/.vimrc

echo '> Debian acts as a Router now'
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

echo '> Disable IPv6'
echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf

echo '> Setup Appliance Banner for /etc/issue & /etc/issue.net'
echo "=============================" | tee /etc/issue /etc/issue.net > /dev/null
echo " Netshoot Virtual Appliance" | tee -a /etc/issue /etc/issue.net > /dev/null
echo "=============================" | tee -a /etc/issue /etc/issue.net > /dev/null
sed -i 's/#Banner none/Banner \/etc\/issue.net/g' /etc/ssh/sshd_config


sed -i 's/#Banner none/Banner \/etc\/issue.net/g' /etc/ssh/sshd_config

echo '> Done'
