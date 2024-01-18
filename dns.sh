#!/bin/bash
sed -i "s/dhcp4: yes/dhcp4: no/g" /etc/netplan/00-installer-config.yaml
nic=`ifconfig | awk 'NR==1{print $1}'`
read -p "IP Estática: " staticip 
read -p "IP router: " gatewayip
read -p "Servidores DNS: " nameserversip
read -p "Dominio: " dominio
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
cat > /etc/nsswitch.conf <<EOF
passwd:         files systemd
group:          files systemd
shadow:         files
gshadow:        files

hosts:          dns files
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis
EOF
echo "Nsswitch configurado correctamente"
read -p "Direccion inversa: " inversa
cat > /etc/bind/named.conf.local <<EOF
zone "$dominio" {
        type master;
        file "/etc/bind/db.$dominio";
};

zone "$inversa.in-addr-arpa" {
        type master;
        file "etc/bind/db.$inversa";
};
EOF
echo "Zonas configuradas correctamente"

