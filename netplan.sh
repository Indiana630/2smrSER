#!/bin/bash
#
# Creates a backup
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bk_`date +%Y%m%d%H%M`
# Changes dhcp from 'yes' to 'no'
sed -i "s/dhcp4: yes/dhcp4: no/g" /etc/netplan/00-installer-config.yaml
# Retrieves the NIC information
nic=`ifconfig | awk 'NR==1{print $1}'`
# Ask for input on network configuration
read -p "IP Estática: " staticip 
read -p "IP router: " gatewayip
read -p "Servidores DNS: " nameserversip
read -p "Dominio: " dominio
echo
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  ethernets:
    $nic
      addresses:
      - $staticip
      gateway4: $gatewayip
      nameservers:
       addresses: [$nameserversip]
       search: [$dominio]
EOF
sudo netplan apply
echo "==========================="
echo
