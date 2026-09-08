#!/bin/bash

set -x -v

echo "SERVER_IP       ${SERVER_IP}"
echo "IPSEC_PSK       ${IPSEC_PSK}"
echo "USERNAME  ${USERNAME}"
echo "PASSWORD  ${PASSWORD}"

# strongSwan
cat > /etc/ipsec.conf <<EOF
# ipsec.conf - strongSwan IPsec configuration file

conn myvpn
  auto=add
  keyexchange=ikev1
  authby=secret
  type=transport
  left=%defaultroute
  leftprotoport=17/1701
  rightprotoport=17/1701
  right=$SERVER_IP
  ike=aes128-sha1-modp2048
  esp=aes128-sha1
EOF

cat > /etc/ipsec.secrets <<EOF
: PSK "$IPSEC_PSK"
EOF

chmod 600 /etc/ipsec.secrets

# xl2tpd

cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[lac myvpn]
lns = $SERVER_IP
ppp debug = yes
pppoptfile = /etc/ppp/options.l2tpd.client
length bit = yes
EOF

cat > /etc/ppp/options.l2tpd.client <<EOF
ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-chap
noccp
noauth
mtu 1280
mru 1280
noipdefault
defaultroute
usepeerdns
connect-delay 5000
name "$USERNAME"
password "$PASSWORD"
EOF

chmod 600 /etc/ppp/options.l2tpd.client

# start

mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

systemctl restart strongswan-starter
systemctl restart xl2tpd

echo "Service Finished"


# Ubuntu and Debian

# https://github.com/hwdsl2/setup-ipsec-vpn/issues/701
ipsec up myvpn

echo "c myvpn" > /var/run/xl2tpd/l2tp-control

# Get ClientIP until not null
while true; do
  # ClientIP=$(ip route | grep default | cut -d " " -f 3)
  ClientIP=$(ifconfig | grep broadcast | tr -s ' ' | cut -d ' ' -f 3)
  if [ -n "$ClientIP" ]; then
    break
  fi
  sleep 1
done

echo "${SERVER_IP} <==> ${ClientIP}"

route add ${SERVER_IP} gw ${ClientIP}

# Check ppp0 exists
while true; do
  route add default dev ppp0
  if [ $? -eq 0 ]; then
    break
  fi
  echo $msg
  sleep 1
done



echo "Initial Finished"

/bin/bash
