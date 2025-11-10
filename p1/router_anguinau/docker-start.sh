#!/bin/sh
set -e

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
