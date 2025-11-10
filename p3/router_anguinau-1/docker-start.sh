#!/bin/sh
set -e

LOOPBACK_IP=1.1.1.1 # Adresse IP de l'interface loopback.

IF_0_NAME=eth0 # Interface réseau vers leaf-1.
IF_1_NAME=eth1 # Interface réseau vers leaf-2.
IF_2_NAME=eth2 # Interface réseau vers leaf-3.

IF_0_IP=10.1.1.1/30 # Adresse IP de l'interface vers leaf-1.
IF_1_IP=10.1.1.5/30 # Adresse IP de l'interface vers leaf-1.
IF_2_IP=10.1.1.9/30 # Adresse IP de l'interface vers leaf-1.

FRR_CONF=/etc/frr/frr.conf # Chemin du fichier de configuration FRR.

OSPF_NET_1=10.1.1.0/30 # Réseau du lien OSPF vers leaf-1.
OSPF_NET_2=10.1.1.4/30 # Réseau du lien OSPF vers leaf-2.
OSPF_NET_3=10.1.1.8/30 # Réseau du lien OSPF vers leaf-3.

AS_ID=1 # Identifiant du système autonome.

LEAF1_IP=1.1.1.2 # Adresse IP de loopback de leaf-1.
LEAF2_IP=1.1.1.3 # Adresse IP de loopback de leaf-2.
LEAF3_IP=1.1.1.4 # Adresse IP de loopback de leaf-3.

# Donne une addresse IP à l'interface loopback.
ip addr add "$LOOPBACK_IP/32" dev 'lo'

# Active l'interface loopback.
ip link set dev 'lo' up

# Donne des adresses IP aux interfaces vers les leafs.
ip addr add "$IF_0_IP" dev "$IF_0_NAME"
ip addr add "$IF_1_IP" dev "$IF_1_NAME"
ip addr add "$IF_2_IP" dev "$IF_2_NAME"

# Active les interfaces vers les leafs.
ip link set dev "$IF_0_NAME" up
ip link set dev "$IF_1_NAME" up
ip link set dev "$IF_2_NAME" up

# Met à jour la configuration FRR avec les variables.
sed -i "s|\$LOOPBACK_IP|$LOOPBACK_IP|g" "$FRR_CONF"

sed -i "s|\$OSPF_NET_1|$OSPF_NET_1|g" "$FRR_CONF"
sed -i "s|\$OSPF_NET_2|$OSPF_NET_2|g" "$FRR_CONF"
sed -i "s|\$OSPF_NET_3|$OSPF_NET_3|g" "$FRR_CONF"

sed -i "s|\$AS_ID|$AS_ID|g" "$FRR_CONF"

sed -i "s|\$LEAF1_IP|$LEAF1_IP|g" "$FRR_CONF"
sed -i "s|\$LEAF2_IP|$LEAF2_IP|g" "$FRR_CONF"
sed -i "s|\$LEAF3_IP|$LEAF3_IP|g" "$FRR_CONF"

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
