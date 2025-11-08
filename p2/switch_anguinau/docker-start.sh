#!/bin/sh
set -e

BRIDGE_NAME=br-underlay
BRIDGE_GATES="eth0 eth1"

ip link add "$BRIDGE_NAME" type 'bridge'
ip link set dev "$BRIDGE_NAME" up

for BRIDGE_GATE in $BRIDGE_GATES; do

    ip link set dev "$BRIDGE_GATE" up
    ip link set dev "$BRIDGE_GATE" master "$BRIDGE_NAME"
done

exec tail -f '/dev/null'
