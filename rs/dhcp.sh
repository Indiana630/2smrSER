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
  if [ adaptadores != 1 and adaptadores != 2 ]
  then
  read -p "Cuantos adaptadores vas a usar 1 o 2" adaptadores
  elif [ adaptadores = 1 ]
  then
  netplan1
  elif [ adaptadores = 2 ]
  then
  netplan2
  fi
then

}

netplan1() {
staticip
gatewayip
nameserversip
dominio
echo
cat > /etc/netplan/00-installer-config.yaml <<EOF
network:
  version: 2
  ethernets:
    $nic
      dhcp4: false
      addresses:
      - $staticip
      gateway4: $gatewayip
      nameservers:
       addresses: [$nameserversip]
       search: [$dominio]
EOF
sudo netplan apply
echo "Netplan configurado correctamente"
}

staticip() {
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

gatewayip() {
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

nameserversip() {
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

dominio() {
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

