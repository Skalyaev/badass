#!/bin/sh
set -e

SELF_IF=eth0 # Interface réseau reliée au routeur.
SELF_IP=20.1.1.2/24 # Adresse IP de l’hôte dans le réseau.

# Assigne une adresse IP à l’interface réseau reliée au routeur.
# Identifie l'hôte sur le réseau.
ip addr add "$SELF_IP" dev "$SELF_IF"

# Active l’interface réseau reliée au routeur.
ip link set dev "$SELF_IF" up

# Maintient le conteneur en vie, /sbin/tini permet un arrêt propre.
exec tail -f '/dev/null'
