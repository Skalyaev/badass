#!/bin/sh
set -e

SELF_IF=eth1
SELF_IP=30.1.1.2/24

ip addr add "$SELF_IP" dev "$SELF_IF"
ip link set dev "$SELF_IF" up

exec tail -f '/dev/null'
