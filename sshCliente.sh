#!/bin/bash
read -p "Antes de comenzar, recuerda tener creada la carpeta .ssh en el servidor, sin esta el script no funcionara (Presiona enter para continuar) " si
read -p "IP servidor: " ipserver
ssh-keygen -t rsa
scp /home/usuario/.ssh/id_rsa.pub usuario@$ipserver:/home/usuario/
scp sshServidor.sh usuario@$ipserver:/home/usuario/
echo "Archivo de autorizaciones creado correctamente, porfavor continue en el servidor..."
echo "Conectando con el servidor..."
ssh usuario@$ipserver
echo "SSH configurado satisfactoriamente"
