#!/bin/bash

# Verificar si el script se está ejecutando con privilegios de superusuario
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario." >&2
  exit 1
fi

instalarApache() {
  apt update
  apt install -y apache2
}

confWeb() {
  read -p "Ingrese el FQDN de la web (en blanco para usar la IP de la máquina): " fqdn
  read -p "Ingrese el nombre de la web: " site_name
  read -p "Ingrese el puerto (80 por defecto): " port
  port=${port:-80}  # Si no se proporciona un puerto, establecer el valor predeterminado en 80

  if [ -z "$fqdn" ]; then
    document_root="/var/www/html/$site_name"
  else
    document_root="/var/www/$fqdn"
  fi

  mkdir -p "$document_root"

  cat << EOF > "$document_root/index.html"
<!DOCTYPE html>
<html>
<head>
  <title>$site_name</title>
</head>
<body>
  <h1>Bienvenido a $site_name</h1>
  <p>Este es el sitio web de $site_name.</p>
</body>
</html>
EOF

  conf_file="/etc/apache2/sites-available/$site_name.conf"
  cat << EOF > "$conf_file"
<VirtualHost *:$port>
    ServerAdmin webmaster@$fqdn
    ServerName $fqdn
    DocumentRoot $document_root

    ErrorLog \${APACHE_LOG_DIR}/$site_name-error.log
    CustomLog \${APACHE_LOG_DIR}/$site_name-access.log combined
</VirtualHost>
EOF

  a2ensite "$site_name"

  systemctl restart apache2

  echo "El sitio web $site_name se ha configurado correctamente en Apache2."
}

read -p "¿Desea instalar un servidor DNS? (s/n): " install_dns

if [ "$install_dns" = "s" ]; then
  # DNS AQUÍ
  echo "Puedes incluir aquí el código para instalar el servidor DNS."
fi

read -p "¿Desea instalar y configurar Apache2? (s/n): " instalarApache_respuesta

if [ "$instalarApache_respuesta" = "s" ]; then
  instalarApache
fi

while true; do
  read -p "¿Desea configurar un nuevo sitio web? (s/n): " nuevoSitio
  if [ "$nuevoSitio" != "s" ]; then
    break
  fi
  confWeb
done

echo "El programa ha finalizado."
