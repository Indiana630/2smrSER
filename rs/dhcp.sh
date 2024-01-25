#!/bin/bash
menu() {
echo "1. Instalar servicio dhcp"
echo "2. Configurar adactador de red (netplan)"
echo "3. Configurar servicio dhcp"
read -p "Escoje una opccion" menuresp
if [ menuresp = 1 ]
apt install isc-dhcp-server
}
