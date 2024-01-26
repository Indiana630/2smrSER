#!/bin/bash
menu() {
echo "Realizado por Darío y Pepe"
echo "1. Instalar servicio dhcp"
echo "2. Configurar servicio dhcp"
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
  if [ adaptadores != 1 and adaptadores != 2 ]
  then
    read -p "Cuantos adaptadores vas a usar 1 o 2" adaptadores
    if [ adaptadores = 1 ]
    then
    read -p "¿Cual es el nombre del adaptador?Ej. enp0s3" adapt1
    elif [ adaptadores = 2 ]
    then
    read -p "¿Cal es el nombre del adaptador 1?Ej. enp0s3" adapt1
    read -p "¿Cal es el nombre del adaptador 2?Ej. enp0s8" adapt2
    fi
  elif [ adaptadores = 1 ]
  then
    conf1
  elif [ adaptadores = 2 ]
  then
    conf2
  fi
fi
}

conf1() {
netplan1
echo "Configurando interfaces"
cat > /etc/default/isc-dhcp-server <<EOF
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid
# Additional options to start dhcpd with.
#       Don't use options -cf or pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP request?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="$adapt1"
INTERFACESv6=""
EOF
sleep 1
echo "Interfaces configuradas"
sleep 2
clear
}

netplan1() {
staticip1
gatewayip1
nameserversip1
dominio1
clear
echo "Configurando netplan"
cat > /etc/netplan/00-installer-config.yaml <<EOF
network:
  version: 2
  ethernets:
    $adapt1
      dhcp4: false
      addresses:
      - $staticip
      gateway4: $gatewayip
      nameservers:
       addresses: [$nameserversip]
       search: [$dominio]
EOF
sudo netplan apply
sleep 1
echo "Netplan configurado"
sleep 2
clear
}

staticip1() {
read -p "IP Estática Ej. 192.168.100.10/24: " staticip
read -p "¿Estas seguro?(y/n)" resp
if [ $resp = "y" ]
then
echo "OK"
elif [ $resp = "n" ]
then
staticip
else
staticip
fi
}

gatewayip1() {
read -p "IP router: " gatewayip
read -p "¿Estas seguro?(y/n)" resp
if [ $resp = "y" ]
then
echo "OK"
elif [ $resp = "n" ]
then
gatewayip
else
gatewayip
fi
}

nameserversip1() {
read -p "Servidores DNS: " nameserversip
read -p "¿Estas seguro?(y/n)" resp
if [ $resp = "y" ]
then
echo "OK"
elif [ $resp = "n" ]
then
nameserversip
else
nameserversip
fi
}

dominio1() {
read -p "Dominio: " dominio
read -p "¿Estas seguro?(y/n)" resp
if [ $resp = "y" ]
then
echo "OK"
elif [ $resp = "n" ]
then
dominio
else
dominio
fi
}
menu
