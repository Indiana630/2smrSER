#!/bin/bash
menu() {
clear
echo "Realizado por Pepe Cabeza y Dario Moreno"
echo " Bienvenido al home de 2SMR ¿con que te puedo ayudar?"
echo "1. Configurar Netplan (SSH y FTP)"
echo "2. Configurar servicio SSH"
echo "3. Configurar Servicio FTP"
echo "4. Configurar Servicio DNS"
echo "5. Salir"
echo -n "Escoger opcion: "
read opcion
if [  $opcion = "1" ]
then
  netplan
elif [ $opcion = "2" ]
then
  ssh
elif [ $opcion = "3" ]
then
  ftp
elif [ $opcion = "4" ]
then
  dns
elif [ $opcion = "5" ]
then
  echo "Saliendo del programa..."
else
  clear
  echo "Opcion incorrecta"
  menu
fi
}

ssh() {
    clear
    echo "Ejecutando netplan..."
    ./rs/netplan.sh
    sleep 1
}

ssh() {
    clear
    echo "Ejecutando SSH..."
    ./rs/sshCliente.sh
    sleep 1
}

ftp() {
    clear
    echo "Ejecutando FTP..."
    ./rs/ftp.sh
    sleep 1
}

dns() {
    clear
    echo "¿Que desea hacer?"
    echo "1) DNS CLIENTE"
    echo "2) DNS SERVIDOR"
    echo -n "Escoje una opcion: "
    read -n opcionDNS
    sleep 1

    if [ $opcionDNS == "1"]
    then
        clear 
        echo "Ejecutando configurador DNS Cliente...."
        ./rs/dnsclient.sh
    elif [ $opcionDNS == "2"]
    then
        clear 
        echo "Ejecutando configurador DNS Cliente...."
        ./rs/dns.sh
    else
        clear
        echo "Opción incorrecta"
        menu
    fi

}

chmod +x rs/dns.sh
chmod +x rs/dnsclient.sh
chmod +x rs/ftp.sh
chmod +x rs/netplan.sh
chmod +x rs/sshCliente.sh
chmod +x rs/sshServidor.sh
menu