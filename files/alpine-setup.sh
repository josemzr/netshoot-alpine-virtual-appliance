# Bootstrap script

set -xeu

FILE_CUSTOMIZATION="/etc/ran_customization"

#
# If customization was already launch, exit right away
#
if [ -s $FILE_CUSTOMIZATION ]
then
    exit 0
fi

HOSTNAME="netshoot"
IP_ADDRESS=$(/opt/getOvfProperty.py "guestinfo.ipaddress" | cut -f1 -d"/")
NETPREFIX=$(/opt/getOvfProperty.py "guestinfo.netprefix" | awk -F ' ' '{print $1}')
GATEWAY=$(/opt/getOvfProperty.py "guestinfo.gateway" | cut -f1 -d"/")
DNS_SERVER=$(/opt/getOvfProperty.py "guestinfo.dns")
ROOT_PASSWORD=$(/opt/getOvfProperty.py "guestinfo.password")
ADD_TLS_CERTIFICATE=$(/opt/getOvfProperty.py "guestinfo.add_tls_certificate")
SSH_KEY=$(/opt/getOvfProperty.py "guestinfo.sshkey")


configureDHCP() {
    echo -e "Configuring network using DHCP..." > /dev/console
    cat > /etc/network/interfaces << __CUSTOMIZE_ALPINE__
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
__CUSTOMIZE_ALPINE__

    echo -e "Restarting Network ..." > /dev/console
    rc-service networking restart
}

configureStaticNetwork() {
    echo -e "Configuring Static IP Address ..." > /dev/console
    cat > /etc/network/interfaces << __CUSTOMIZE_ALPINE__

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address ${IP_ADDRESS}/${NETPREFIX}
gateway ${GATEWAY}
__CUSTOMIZE_ALPINE__

    echo -e "Restarting Network ..." > /dev/console
    rc-service networking restart
}

configureDNS(){
echo -e "Configuring DNS ..." > /dev/console
setup-dns -d netshoot.com -n "${DNS_SERVER}"
}

configureHostname() {
    echo -e "Configuring hostname ..." > /dev/console
    setup-hostname -n "${HOSTNAME}"
	cat > /etc/hosts <<-EOF
	127.0.0.1    ${HOSTNAME}.netshoot.com localhost.localdomain localhost
	::1          localhost localhost.localdomain
	EOF
    rc-service hostname restart
}


configureRootPassword() {
    echo -e "Configuring root password ..." > /dev/console
    echo "root:${ROOT_PASSWORD}" | /usr/sbin/chpasswd
}

createCustomizationFlag() {
    # Ensure that we don't run the customization again
    touch /etc/ran_customization
}

addCertStore() {
    # Adding additional TLS certificate to the system datastore in case it is needed (i.e to connect to an upstream HTTPS proxy for TLS introspection)
    echo -e "Adding additional TLS certificate ..." > /dev/console
    if [ "${ADD_TLS_CERTIFICATE}" != "null" ] && [ ! -z "${ADD_TLS_CERTIFICATE}" ]; then
        mkdir /usr/share/ca-certificates/extra
        echo ${ADD_TLS_CERTIFICATE} | sed -e 's/BEGIN /BEGIN_/g' -e 's/PRIVATE /PRIVATE_/g' -e 's/END /END_/g' -e 's/ /\n/g' -e 's/BEGIN_/BEGIN /g' -e 's/PRIVATE_/PRIVATE /g' -e 's/END_/END /g' > /usr/share/ca-certificates/extra/add_tls_cert.crt
        echo "extra/add_tls_cert.crt" >> /etc/ca-certificates.conf
        /usr/sbin/update-ca-certificates
    else
        echo -e "Additional TLS certificate not present. Skipping..." > /dev/console
    fi
}

addSshKey() {
    echo -e "Adding SSH key to root user ..." > /dev/console
    if [ "${SSH_KEY}" != "null" ] && [ ! -z "${SSH_KEY}" ]; then
        echo ${SSH_KEY} > /root/.ssh/authorized_keys
    else
        echo -e "SSH key not present. Skipping..." > /dev/console
    fi
}

if [ -e /etc/ran_customization ]; then
    exit
else
    LOG_FILE=/var/log/bootstrap.log
    LOG_FILE=/var/log/debian-customization-debug.log
    set -x
    exec 2> ${LOG_FILE}
    echo
    echo "### WARNING -- DEBUG LOG CONTAINS ALL EXECUTED COMMANDS WHICH INCLUDES CREDENTIALS -- WARNING ###"
    echo "### WARNING --             PLEASE REMOVE CREDENTIALS BEFORE SHARING LOG            -- WARNING ###"
    echo
fi

# Leaving blank IP address or gateway will force DHCP
if [ -z "${IP_ADDRESS}" ] || [ -z "${GATEWAY}" ] || [ "${IP_ADDRESS}" == "null" ] || [ "${GATEWAY}" == "null" ]; then

    configureDHCP
    configureHostname
    configureRootPassword
    addCertStore
    addSshKey
    createCustomizationFlag

    else

    configureStaticNetwork
    configureHostname
    configureDNS
    configureRootPassword
    addCertStore
    addSshKey
    createCustomizationFlag

    fi
