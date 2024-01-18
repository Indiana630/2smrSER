#!/bin/bash
ssh-keygen -t rsa
scp /home/usuario/.ssh/authorized_keys usuario@$ipserver:/home/usuario/.ssh
cat /home/usuario/.ssh/id_rsa.pub >> /home/usuario/.ssh/authorized_keys
chmod go-rw /home/usuario/.ssh/authorized_keys
echo "Archivo de autorizaciones creado correctamente, copiando al servidor..."
read -p "IP servidor: " ipserver
scp /home/usuario/.ssh/authorized_keys usuario@$ipserver:/home/usuario/.ssh
echo "Claves injectadas al servidor correctamente"
echo "Conectando con el servidor y reiniciando servicios..."
scp /home/usuario/.ssh/sshServidor.sh usuario@$ipserver:/home/usuario/
ssh usuario@$ipserver

exit
echo "SSH configurado satisfactoriamente"
