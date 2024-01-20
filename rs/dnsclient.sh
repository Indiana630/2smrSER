#!/bin/bash
echo "Configurando Netplan..."
sed -i "s/dhcp4: yes/dhcp4: no/g" /etc/netplan/01-network-manager-all.yaml
nic=`ifconfig | awk 'NR==1{print $1}'`
read -p "IP Estática Ej. 192.168.100.10/24: " staticip 
read -p "IP router: " gatewayip
read -p "Servidores DNS: " nameserversip
read -p "Dominio: " dominio
TTL='$TTL'
cat > /etc/netplan/01-network-manager-all.yaml <<EOF
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
echo "Netplan configurado correctamente"
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
echo "Resolvconf operativo"
