#!/bin/bash
menu() {
Menu de resolucion DNS
echo "1. Resolver nombreDNS"
echo "2. Resolver nombreDNS a partir de uno ya existente"
echo "3. Salir"
read menuselect
if [ $menuselect = "1" ]
then
  resolverip
elif [ $menuselect = "2" ]
then
  resolvernombre
elif [ $menuselect = "3" ]
then
  echo "El servidor dns ha sido configurado al 100% y esta totalmente operativo, que lo disfrutes"
    rm -f /etc/bind/db.$inversa.nuevo
    rm -f /etc/bind/db.$dominio.nuevo
else
  clear
  echo "No te entiendo, repitamos"
  menu
fi
}


aplicarcambios() {
if [ $respuesta = "y" ]
then
  if [ $menuselect = "1" ]
  then
    cat /etc/bind/db.$dominio.nuevo >> /etc/bind/db.$dominio
    cat /etc/bind/db.$inversa.nuevo >> /etc/bind/db.$inversa
    rm -f /etc/bind/db.$inversa.nuevo
    rm -f /etc/bind/db.$dominio.nuevo
    echo "Tus cambios han sido guardados, volvemos al menu"
    sleep 3
    clear
    menu
  elif [ $menuselect = "2" ]
  then
    cat /etc/bind/db.$dominio.nuevo >> /etc/bind/db.$dominio
    rm -f /etc/bind/db.$dominio.nuevo
    echo "Tus cambios han sido guardados, volvemos al menu"
    sleep 3
    clear
    menu
  fi
elif [ $respuesta = "n" ]
then
  rm -f /etc/bind/db.$inversa.nuevo
  rm -f /etc/bind/db.$dominio.nuevo
  echo "Tus cambios no seran guardados, volvemos al menu"
  sleep 3
  clear
  menu
else
  read -p "No me ha quedado claro, ¿puede repetir?(y/n): " respuesta
  aplicarcambios
fi
}


resolverip() {
read -p "Dime el nombre de dominio a resolver: " dominioresolv
read -p "Dime la ip correspondiente: " ipdominio
read -p "Dime la ip correspondiente(la parte de hosts): " inversahost
cat > /etc/bind/db.$dominio.nuevo <<EOF
$dominioresolv  IN  A  $ipdominio
EOF
cat > /etc/bind/db.$inversa.nuevo <<EOF
$inversahost  IN  PTR  $dominioresolv
EOF
echo "La resolucion del nombreDNS ha sido correcta los parametros son:"
echo "Dominio a resover: " $dominioresolv
echo "Ip correspondiente: " $ipdominio
echo "Ip(host): " $inversahost
read -p "¿Deseas aplicar los cambios?(y/n): " respuesta
aplicarcambios
}


resolvernombre() {
read -p "Dime el nombre de dominio a resolver: " dominioresolv
read -p "Dime la dominio ya existente: " dominiocor
cat > /etc/bind/db.$dominio.nuevo <<EOF
$dominioresolv  IN  CNAME  $dominiocor
EOF
echo "La resolucion del nombreDNS ha sido correcta los parametros son:"
echo "Dominio a resover: " $dominioresolv
echo "Dominio existente: " $dominiocor
read -p "¿Deseas aplicar los cambios?(y/n): " respuesta
aplicarcambios
}

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
cp /etc/bind/db.local /etc/bind/db.default
cat > /etc/bind/db.default <<EOF
;
;BIND data file for local loopback interface
;
"$TTL"    604800
@       IN      SOA     servidor.$dominio. root.$dominio. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TLL
;
;
  IN  NS  servidor.$dominio.
EOF
cp /etc/bind/db.default /etc/bind/db.$dominio
cp /etc/bind/db.default /etc/bind/db.$inversa
rm -f /etc/bind/db.default
clear
echo "Vamos a configurar la resolucion de las ips"
menu
