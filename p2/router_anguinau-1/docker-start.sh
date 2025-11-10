#!/bin/sh
set -e

VXLAN_NAME=vxlan10 # Nom de l'interface VXLAN.
VXLAN_ID=10 # Identifiant du VXLAN (VNI).

VTEP_IF=eth0 # Interface réseau qui envoie/reçoit les paquets VXLAN (VTEP).
VTEP_IP=172.16.0.1/24 # Adresse IP de l'interface VTEP.
VTEP_GROUP_IP=239.1.1.10 # Adresse multicast de replication BUM.
VTEP_GROUP_PORT=4789 # Port UDP utilisé pour le transport VXLAN.

BRIDGE_NAME=br0 # Nom de l'interface bridge utilisée pour le VXLAN.
BRIDGE_GATE=eth1 # Interface d'accès au bridge (port d'accès).

SELF_IF="$BRIDGE_NAME" # Interface réseau de l'hôte (le bridge).
SELF_IP=30.1.1.3/24 # Adresse IP de l'hôte dans le réseau.

# Donne une addresse IP à l'interface VTEP.
# Identifie l'hôte pour les communications VXLAN.
ip addr add "$VTEP_IP" dev "$VTEP_IF"

# Active l'interface VTEP.
ip link set dev "$VTEP_IF" up

# Crée une interface réseau virtuelle de type bridge.
# Utilisée pour relier le VXLAN et le port d'accès.
ip link add "$BRIDGE_NAME" type 'bridge'

# Donne une adresse IP au bridge.
# Identifie l'hôte sur le réseau.
ip addr add "$SELF_IP" dev "$SELF_IF"

# Active le bridge.
ip link set dev "$BRIDGE_NAME" up

# Crée une interface réseau virtuelle de type VXLAN.
#
# Identifiée par VXLAN_ID sur l'interface VTEP_IF.
# Utilisant VTEP_GROUP_IP pour la réplication BUM.
# Ciblant le port VTEP_GROUP_PORT en UDP pour toute transmission.
ip link add "$VXLAN_NAME" type 'vxlan' \
    id "$VXLAN_ID" dev "$VTEP_IF" \
    group "$VTEP_GROUP_IP" \
    dstport "$VTEP_GROUP_PORT"

# Active l'interface VXLAN et le port d'accès.
ip link set dev "$VXLAN_NAME" up
ip link set dev "$BRIDGE_GATE" up

# Attache l'interface VXLAN et le port d'accès au bridge.
ip link set dev "$VXLAN_NAME" master "$BRIDGE_NAME"
ip link set dev "$BRIDGE_GATE" master "$BRIDGE_NAME"

# Set le nombre maximum de descripteurs de fichiers.
# Permet de retirer un message d'erreur dans les logs de FRR.
ulimit -n 100000

# Démarre les démons FRR.
# Permet au système de router en BGP/OSPF/IS-IS.
#
# -d : Lance le processus en arrière-plan.
# -F : Format de configuration utilisé.
# -A : Adresse autorisée pour les connexions vtysh.
/usr/lib/frr/zebra -d -F 'traditional' -A '127.0.0.1' -s '90000000'
/usr/lib/frr/bgpd  -d -F 'traditional' -A '127.0.0.1'
/usr/lib/frr/ospfd -d -F 'traditional' -A '127.0.0.1'
/usr/lib/frr/isisd -d -F 'traditional' -A '127.0.0.1'

# Maintient le conteneur en vie, /sbin/tini permet un arrêt propre.
exec tail -f '/dev/null'
