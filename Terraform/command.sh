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

# Crea una página de error personalizada
sudo mkdir -p /var/www/erik/errors
echo "<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Error - Página no encontrada</title>
</head>
<body>
    <h1>¡Oops! Algo salió mal.</h1>
    <p>La página que buscas no está disponible o hubo un error en el servidor. Por favor, inténtalo de nuevo más tarde.</p>
</body>
</html>" | sudo tee /var/www/erik/errors/error.html > /dev/null

# Corrige los permisos
sudo chown -R www-data:www-data /var/www/erik
sudo chmod -R 755 /var/www/erik

# Cambia la configuración del puerto de Apache
sudo sed -i 's/Listen 80/Listen 1616/' /etc/apache2/ports.conf

# Configura Apache para usar el nuevo directorio en el puerto 1616, con redirección y página de error personalizada
sudo bash -c 'cat > /etc/apache2/sites-available/erik.conf <<EOF
<VirtualHost *:1616>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/erik
    <Directory /var/www/erik>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # Redirige /direccionantigua a la raíz del sitio
    Redirect 301 /direccionantigua /

    # Autenticación en la carpeta admin
    <Directory /var/www/erik/view/admin>
        Options Indexes FollowSymLinks
        AuthType Basic
        AuthName "Área Administrativa"
        AuthUserFile /var/www/erik/.htpasswd
        Require valid-user
    </Directory>

    # Configuración de espacios para usuarios
    <Directory /var/www/erik/usuariosDir/usuario1>
        Options Indexes FollowSymLinks
        AuthType Basic
        AuthName "Espacio de usuario1"
        AuthUserFile /var/www/erik/.htpasswd_usuario1
        Require valid-user
    </Directory>

    <Directory /var/www/erik/usuariosDir/usuario2>
        Options Indexes FollowSymLinks
        AuthType Basic
        AuthName "Espacio de usuario2"
        AuthUserFile /var/www/erik/.htpasswd_usuario2
        Require valid-user
    </Directory>

    ErrorDocument 404 /errors/error.html
    ErrorDocument 500 /errors/error.html
    ErrorLog \${APACHE_LOG_DIR}/erik_error.log
    CustomLog \${APACHE_LOG_DIR}/erik_access.log combined
</VirtualHost>
EOF'

# Crea directorios para los usuarios
sudo mkdir -p /var/www/erik/usuariosDir/usuario1
sudo mkdir -p /var/www/erik/usuariosDir/usuario2

# Establece permisos para los directorios de los usuarios
sudo chown -R www-data:www-data /var/www/erik/usuariosDir/usuario1
sudo chmod -R 755 /var/www/erik/usuariosDir/usuario1

sudo chown -R www-data:www-data /var/www/erik/usuariosDir/usuario2
sudo chmod -R 755 /var/www/erik/usuariosDir/usuario2

# Crea archivos .htpasswd para cada usuario
echo "usuario1:$(openssl passwd -crypt password1)" | sudo tee /var/www/erik/.htpasswd_usuario1 > /dev/null
echo "usuario2:$(openssl passwd -crypt password2)" | sudo tee /var/www/erik/.htpasswd_usuario2 > /dev/null

# Deshabilita el sitio predeterminado y habilita el nuevo
sudo a2dissite 000-default.conf
sudo a2ensite erik.conf

# Recarga Apache para aplicar los cambios
sudo systemctl reload apache2

# Habilita y arranca el servicio Apache
sudo systemctl enable apache2
sudo systemctl start apache2
