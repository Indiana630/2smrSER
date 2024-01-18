#!/bin/bash
read -p "IP servidor: " ipserver
ssh-keygen -t rsa
scp /home/usuario/.ssh/authorized_keys usuario@$ipserver:/home/usuario/.ssh
scp /home/usuario/.ssh/sshServidor.sh usuario@$ipserver:/home/usuario/
echo "Archivo de autorizaciones creado correctamente, porfavor continue en el servidor..."
echo "Conectando con el servidor..."
ssh usuario@$ipserver
echo "SSH configurado satisfactoriamente"
