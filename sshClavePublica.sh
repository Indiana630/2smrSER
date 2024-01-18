#!/bin/bash
ssh-keygen -t rsa
cat /home/usuario/.ssh/id_rsa.pub >> /home/usuario/.ssh/authorized_keys
chmod go-rw /home/usuario/.ssh/authorized_keys
echo "Archivo de autorizaciones creado correctamente, copiando al servidor..."
read -p "IP servidor: " ipserver
scp /home/usuario/.ssh/authorized_keys usuario@$ipserver:/home/usuario/.ssh
echo "Claves injectadas al servidor correctamente"
echo "Conectando con el servidor y reiniciando servicios..."
ssh usuario@$ipserver
systemctl reload ssh
system status ssh
exit
echo "SSH configurado satisfactoriamente"
