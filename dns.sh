#!/bin/bash
sed -i "s/dhcp4: yes/dhcp4: no/g" /etc/netplan/00-installer-config.yaml
nic=`ifconfig | awk 'NR==1{print $1}'`
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
netplan apply
cat > /etc/systemd/resolved.conf <<EOF
[Resolve]
DNS=$staticip
Domains=$dominio
EOF
systemctl daemon-reload
systemctl restart systemd-networkd
systemctl restart systemd-resolved
rm -f /etc/resolv.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
echo
