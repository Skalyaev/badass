#!/bin/sh
set -e

BRIDGE_NAME=br-underlay # Nom de l'interface bridge utilisée pour le VXLAN.
BRIDGE_GATES="eth0 eth1" # Interfaces physiques à rattacher au bridge.

# Crée une interface réseau virtuelle de type bridge.
# Utilisée pour relier les interfaces "physiques".
ip link add "$BRIDGE_NAME" type 'bridge'

# Active le bridge.
ip link set dev "$BRIDGE_NAME" up

for BRIDGE_GATE in $BRIDGE_GATES; do

    # Active l'interface physique.
    ip link set dev "$BRIDGE_GATE" up

    # Attache l'interface physique au bridge.
    ip link set dev "$BRIDGE_GATE" master "$BRIDGE_NAME"
done

# Maintient le conteneur en vie, /sbin/tini permet un arrêt propre.
exec tail -f '/dev/null'
