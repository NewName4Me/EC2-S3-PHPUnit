#!/bin/bash
# Actualiza los repositorios e instala paquetes necesarios
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y apache2 apache2-utils openssl git php php-common php-pear

# Habilita el módulo de PHP adecuado para Apache
sudo a2enmod php8.2  # Cambia '8.2' según la versión que instales
sudo systemctl restart apache2

# Crea el nuevo directorio web si no existe y elimina su contenido previo
sudo mkdir -p /var/www/erik
sudo rm -rf /var/www/erik/*

# Clona el repositorio de GitHub
sudo git clone https://github.com/NewName4Me/EC2-S3-PHPUnit.git /tmp/tu_repositorio

# Mueve solo la carpeta deseada al nuevo directorio web
sudo mv /tmp/tu_repositorio/WebPhpEc2/* /var/www/erik/

# Limpia eliminando el repositorio clonado
sudo rm -rf /tmp/tu_repositorio

# Corrige los permisos
sudo chown -R www-data:www-data /var/www/erik
sudo chmod -R 755 /var/www/erik

# Cambia la configuración del puerto de Apache
sudo sed -i 's/Listen 80/Listen 1616/' /etc/apache2/ports.conf

# Configura Apache para usar el nuevo directorio en el puerto 1616
sudo bash -c 'cat > /etc/apache2/sites-available/erik.conf <<EOF
<VirtualHost *:1616>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/erik
    <Directory /var/www/erik>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/erik_error.log
    CustomLog \${APACHE_LOG_DIR}/erik_access.log combined
</VirtualHost>
EOF'

# Deshabilita el sitio predeterminado y habilita el nuevo
sudo a2dissite 000-default.conf
sudo a2ensite erik.conf

# Recarga Apache para aplicar los cambios
sudo systemctl reload apache2

# Habilita y arranca el servicio Apache
sudo systemctl enable apache2
sudo systemctl start apache2
