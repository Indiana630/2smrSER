#!/bin/bash
menu() {
echo "1. Instalar servicio dhcp"
echo "2. Configurar adactador de red (netplan)"
echo "3. Configurar servicio dhcp"
read -p "Escoje una opccion" menuresp
if [ menuresp = 1 ]
then
apt update isc-dhcp-server
apt install isc-dhcp-server
clear
echo "Servicio instalado con exito"
menu
elif [ menuresp = 2 ]
then

}
