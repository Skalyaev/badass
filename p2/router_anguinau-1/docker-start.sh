#!/bin/sh
set -e

VXLAN_NAME=vxlan10
VXLAN_ID=10

VTEP_IF=eth0
VTEP_IP=172.16.0.1/24
VTEP_GROUP_IP=239.1.1.10
VTEP_GROUP_PORT=4789

BRIDGE_NAME=br0
BRIDGE_GATE=eth1

SELF_IF="$BRIDGE_NAME"
SELF_IP=30.1.1.3/24

ip addr add "$VTEP_IP" dev "$VTEP_IF"
ip link set dev "$VTEP_IF" up

ip link add "$BRIDGE_NAME" type 'bridge'

ip addr add "$SELF_IP" dev "$SELF_IF"
ip link set dev "$BRIDGE_NAME" up

ip link add "$VXLAN_NAME" type 'vxlan' \
    id "$VXLAN_ID" dev "$VTEP_IF" \
    group "$VTEP_GROUP_IP" \
    dstport "$VTEP_GROUP_PORT"

ip link set dev "$VXLAN_NAME" up
ip link set dev "$BRIDGE_GATE" up

ip link set dev "$VXLAN_NAME" master "$BRIDGE_NAME"
ip link set dev "$BRIDGE_GATE" master "$BRIDGE_NAME"

ulimit -n 100000
/usr/lib/frr/zebra -d -F 'traditional' -A '127.0.0.1' -s '90000000'
/usr/lib/frr/bgpd  -d -F 'traditional' -A '127.0.0.1'
/usr/lib/frr/ospfd -d -F 'traditional' -A '127.0.0.1'
/usr/lib/frr/isisd -d -F 'traditional' -A '127.0.0.1'

exec tail -f '/dev/null'
