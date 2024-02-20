#!/bin/bash
read -p "IP servidor: " ipserver
ssh-keygen -t rsa
scp /home/usuario/.ssh/id_rsa.pub usuario@$ipserver:/home/usuario/
scp rs/sshServidor.sh usuario@$ipserver:/home/usuario/
echo "Archivo de autorizaciones creado correctamente, porfavor continue en el servidor..."
echo "Conectando con el servidor..."
ssh usuario@$ipserver
echo "SSH configurado satisfactoriamente"
