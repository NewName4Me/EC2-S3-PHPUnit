#!/bin/bash
# Actualiza los repositorios e instala paquetes necesarios
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y apache2 apache2-utils openssl git php php-common php-pear

# Habilita el módulo de PHP adecuado para Apache
sudo a2enmod php8.2  # Cambia '8.2' según la versión que instales
sudo systemctl restart apache2

# Crea el directorio web si no existe y elimina su contenido previo
sudo mkdir -p /var/www/html
sudo rm -rf /var/www/html/*

# Clona el repositorio de GitHub
sudo git clone https://github.com/NewName4Me/EC2-S3-PHPUnit.git /tmp/tu_repositorio

# Mueve solo la carpeta deseada al directorio web
sudo mv /tmp/tu_repositorio/WebPhpEc2/* /var/www/html/

# Limpia eliminando el repositorio clonado
sudo rm -rf /tmp/tu_repositorio

# Corrige los permisos
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Habilita y arranca el servicio Apache
sudo systemctl enable apache2
sudo systemctl start apache2
