#!/bin/bash
mkdir /home/usuario/.ssh
mv id_rsa.pub /home/usuario/.ssh
cat /home/usuario/.ssh/id_rsa.pub >> /home/usuario/.ssh/authorized_keys
chmod go-rw /home/usuario/.ssh/authorized_keys
echo "Reiniciando servicios..."
systemctl restart ssh
systemctl status ssh
