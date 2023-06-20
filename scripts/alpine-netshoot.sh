##
## Alpine
## Setup Network Troubleshooting Packages
##

set -xeu 
echo '> Setup Netshoot Packages...'

echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
apk update 
apk upgrade 
apk add --no-cache \
    python3 \
    apache2-utils \
    bash \
    bind-tools \
    bird \
    bridge-utils \
    busybox-extras \
    conntrack-tools \
    curl \
    dhcping \
    drill \
    ethtool \
    file\
    fping \
    iftop \
    iperf \
    iperf3 \
    iproute2 \
    ipset \
    iptables \
    iptraf-ng \
    iputils \
    ipvsadm \
    httpie \
    jq \
    libc6-compat \
    liboping \
    ltrace \
    mtr \
    net-snmp-tools \
    netcat-openbsd \
    nftables \
    ngrep \
    nmap \
    nmap-nping \
    nmap-scripts \
    openssl \
    py3-pip \
    py3-setuptools \
    scapy \
    socat \
    speedtest-cli \
    openssh \
    strace \
    tcpdump \
    tcptraceroute \
    tshark \
    tmux \
    util-linux \
    vim \
    git \
    perl-utils \
    websocat \
    perl-crypt-ssleay \
    perl-net-ssleay
    
# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin

# Install Termshark
wget https://github.com/gcla/termshark/releases/download/v2.2.0/termshark_2.2.0_linux_x64.tar.gz
tar -xzvf termshark_2.2.0_linux_x64.tar.gz --strip-components=1
rm -rf termshark_2.2.0_linux_x64.tar.gz
chmod +x termshark
mv termshark /usr/local/bin

# Install Carvel tools
curl -L https://carvel.dev/install.sh | bash

# Make the tty-share executable (previously copied from the files folder)
chmod +x /usr/local/bin/tty-share

echo '> Done'

