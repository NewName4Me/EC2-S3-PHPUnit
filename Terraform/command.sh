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

# Configura Apache para usar el nuevo directorio en el puerto 1616, con redirección y autenticación
sudo bash -c 'cat > /etc/apache2/sites-available/erik.conf <<EOF
<VirtualHost *:1616>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/erik
    <Directory /var/www/erik>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
    
    # Redirige /direccionantigua a la raíz del sitio
    RedirectMatch ^/direccionantigua/?$ /

    # Autenticación en la carpeta admin
    <Directory /var/www/erik/view/admin>
        Options Indexes FollowSymLinks
        AllowOverride None
        AuthType Basic
        AuthName "Área Administrativa"
        AuthUserFile /var/www/erik/.htpasswd
        Require valid-user
    </Directory>

    # Configuración de espacios para usuarios
    <Directory /var/www/erik/usuariosDir/usuario1>
        Options Indexes FollowSymLinks
        AllowOverride None
        AuthType Basic
        AuthName "Espacio de usuario1"
        AuthUserFile /var/www/erik/.htpasswd_usuario1
        Require valid-user
    </Directory>

    <Directory /var/www/erik/usuariosDir/usuario2>
        Options Indexes FollowSymLinks
        AllowOverride None
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

# Configura autenticación para usuarios y admin
sudo htpasswd -cb /var/www/erik/.htpasswd admin admin
sudo htpasswd -cb /var/www/erik/.htpasswd_usuario1 usuario1 usuario1
sudo htpasswd -cb /var/www/erik/.htpasswd_usuario2 usuario2 usuario2

# Configura un segundo sitio en el puerto 3030
sudo mkdir -p /var/www/susanaparati
sudo cp -R /var/www/erik/* /var/www/susanaparati/
sudo chown -R www-data:www-data /var/www/susanaparati
sudo chmod -R 755 /var/www/susanaparati

sudo bash -c 'cat > /etc/apache2/sites-available/susanaparati.conf <<EOF
<VirtualHost *:3030>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/susanaparati
    <Directory /var/www/susanaparati>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorDocument 404 /errors/error.html
    ErrorDocument 500 /errors/error.html
    ErrorLog \${APACHE_LOG_DIR}/susanaparati_error.log
    CustomLog \${APACHE_LOG_DIR}/susanaparati_access.log combined
</VirtualHost>
EOF'

# Habilita ambos sitios
sudo a2ensite erik.conf
sudo a2ensite susanaparati.conf

# Habilita ambos puertos en Apache
sudo sed -i '/Listen 1616/a Listen 3030' /etc/apache2/ports.conf

# Recarga Apache para aplicar los cambios
sudo systemctl reload apache2

# Habilita y arranca el servicio Apache
sudo systemctl enable apache2
sudo systemctl start apache2
