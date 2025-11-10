#!/bin/sh
set -e

LOOPBACK_IP=1.1.1.4 # Adresse IP de l'interface loopback.

VXLAN_NAME=vxlan10 # Nom de l'interface VXLAN.
VXLAN_ID=10 # Identifiant du VXLAN (VNI).

VTEP_IF=eth2 # Interface réseau qui envoie/reçoit les paquets VXLAN (VTEP).
VTEP_IP=10.1.1.10/30 # Adresse IP de l'interface VTEP.
VTEP_UDP_PORT=4789 # Port UDP utilisé pour le transport VXLAN.

BRIDGE_NAME=br0 # Nom de l'interface bridge utilisée pour le VXLAN.
BRIDGE_GATE=eth0 # Interface d'accès au bridge (port d'accès).

FRR_CONF=/etc/frr/frr.conf # Chemin du fichier de configuration FRR.

OSPF_NET=10.1.1.8/30 # Réseau du lien OSPF vers le RR.
AS_ID=1 # Identifiant du système autonome.
RR_IP=1.1.1.1 # Adresse de loopback du RR.

# Donne une addresse IP à l'interface loopback.
ip addr add "$LOOPBACK_IP/32" dev 'lo'

# Active l'interface loopback.
ip link set dev 'lo' up

# Donne une addresse IP à l'interface VTEP.
# Identifie l'hôte pour la communication IP vers le RR.
ip addr add "$VTEP_IP" dev "$VTEP_IF"

# Active l'interface VTEP.
ip link set dev "$VTEP_IF" up

# Crée une interface réseau virtuelle de type bridge.
# Utilisée pour relier le VXLAN et le port d'accès.
ip link add "$BRIDGE_NAME" type 'bridge'

# Active le bridge.
ip link set dev "$BRIDGE_NAME" up

# Crée une interface réseau virtuelle de type VXLAN.
#
# Identifiée par VXLAN_ID sur l'interface VTEP_IF.
# Sans groupe multicast: la réplication BUM est gérée par EVPN.
# Ciblant le port VTEP_UDP_PORT en UDP pour toute transmission.
# En désactivant l'apprentissage MAC (géré par EVPN).
ip link add "$VXLAN_NAME" type 'vxlan' \
    id "$VXLAN_ID" dev "$VTEP_IF" \
    local "$LOOPBACK_IP" \
    dstport "$VTEP_UDP_PORT" \
    nolearning

# Active l'interface VXLAN et le port d'accès.
ip link set dev "$VXLAN_NAME" up
ip link set dev "$BRIDGE_GATE" up

# Attache l'interface VXLAN au bridge.
ip link set dev "$VXLAN_NAME" master "$BRIDGE_NAME"
ip link set dev "$BRIDGE_GATE" master "$BRIDGE_NAME"

# Met à jour la configuration FRR avec les variables.
sed -i "s|\$LOOPBACK_IP|$LOOPBACK_IP|g" "$FRR_CONF"
sed -i "s|\$OSPF_NET|$OSPF_NET|g" "$FRR_CONF"
sed -i "s|\$AS_ID|$AS_ID|g" "$FRR_CONF"
sed -i "s|\$RR_IP|$RR_IP|g" "$FRR_CONF"

# Change le propriétaire du fichier de configuration FRR.
chown 'frr:frr' "$FRR_CONF"

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

# Charge la configuration FRR.
vtysh -f "$FRR_CONF"

# Maintient le conteneur en vie, /sbin/tini permet un arrêt propre.
exec tail -f '/dev/null'
