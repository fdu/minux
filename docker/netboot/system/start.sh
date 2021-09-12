#!/bin/sh

IP=$(ip -o -4 addr list $NIC | awk '{print $4}' | cut -d/ -f1)
NETWORK=$(echo $IP | cut -d\. -f1-3)

if [ -z "$IP" ]; then
  echo NIC $NIC does not exist or does not have IPv4 address
  exit
fi

echo NIC: $NIC
echo IP: $IP
echo NETWORK: $NETWORK
sed -i "s/<IP>/$IP/" /etc/dnsmasq.conf
sed -i "s/<NETWORK>/$NETWORK/g" /etc/dnsmasq.conf
SERVER_ROOT_ESCAPED=$(echo $SERVER_ROOT/ | sed "s/\//\\\\\//g")
sed -i "s/<SERVER_ROOT>/$SERVER_ROOT_ESCAPED/" /etc/dnsmasq.conf
sed -i "s/<IP>/$IP/" $SERVER_ROOT/boot/grub.cfg
dnsmasq --no-daemon --log-queries &
#dnsmasq
nginx
tail -f /var/log/nginx/access.log &
echo docker-netboot running...
sleep infinity
