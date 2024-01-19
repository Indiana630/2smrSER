#!/bin/bash
netplan() {
read -p "¿Quieres DHCP activo?(y/n): " dhcp
if $dhcp = y
then
cat > /etc/netplan/00-installer-config.yaml <<EOF
network:
  version: 2
  ethernets:
    $nic
      dhcp4: true
EOF
sudo netplan apply
elif $dhcp = n
then
read -p "IP Estática: " staticip 
read -p "IP router: " gatewayip
read -p "Servidores DNS: " nameserversip
read -p "Dominio: " dominio
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
else
netplan
fi
}
netplan
echo "==========================="
echo
