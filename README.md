---
description: Todo lo necesario para saber como funciona y fue desarrollado este proyecto
icon: aws
cover: .gitbook/assets/Untitled.jpg
coverY: 84
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# README

### Índice

* Quiénes Somos
* Tecnologías
* Configuración Servidor
* Diseño Figma
* Contacto

### Quiénes Somos

| Empleado       | Tarea                     |
| -------------- | ------------------------- |
| tortarod       | Project Manager           |
| eriktortarod   | Full Stack Developer      |
| etorrod1403    | UI/UX Designer            |
| gomogamestudio | Infraestructure Sys/Admin |



### Tecnologías Empleadas

* **Gestor de Proyecto**: Jira.
* **Documentador del código**: JsDoc y PHPDocumentor
* **Documentador del proyecto**: GitBook.
* **Repositorio del codigo**: Github.
* **Despliegue**: AWS
  * VPC
  * EC2
  * Terraform
  * Github Actions
  * S3

### Configuración Servidor Apache&#x20;



1. Configurar direcotorio de ubicación de apache ⇒ traspasado al /var/www/erik
2. Configurar puerto que atiende a las peticiones ⇒  traspasaod al puerto :1616&#x20;
3. Añadir Indexes para en caso de ir a una pagina que no contenga index.php o index.html te muestre el directorio de archivos que tiene esa carpeta en particular y poder navegar a gusto del usuario a la carpeta deseada
4. Redireccionamientos ⇒ si intentas ir a la direccion ip:1616/direccionAntigua ⇒ te mandamos a ip:1616
5. Página de errores ⇒ si intentas ir a un lugar que no existe en nuestro servidor, te mostramos un mensaje de error personalizado por nosotros
6. Sitios Virtuales ⇒ se genera otra pagina en el puerto 3030 con una configuración que podría ser completamente a la original en la direccion /var/www/susanaparati
7. Autenticación de acceso ⇒ a la hora de crear el servidor se generan unos directorios que contienen usuarios que requieren autenticación.  Se generan tal que así : /var/www/erik/usuariosDir/usuario1 que tienen un contraseña dada como usuario1 y nombre usuario1, esta pagina tambien existe en mis documentos del servidor php, es decir si vas a /view/usuariosDir/ habrá carpetas para cada uno de los usuarios, a diferencia del siguiente punto :arrow\_down\_small:
8. Autenticación de accesos a una página ⇒ esta carpeta a diferencia de la anterior no se genera ningun sitio en nuestro servidor para estos usuarios, pero si intentas acceder a /view/admin te pedira datos de administrador para poder acceder

### Enlaces Diseño Figma

#### Version PC&#x20;

{% embed url="https://www.figma.com/proto/DDN1a1kKOHmwWRiycK7Jdt/Clase-Dise%C3%B1o-Web?content-scaling=fixed&node-id=34-251&node-type=canvas&page-id=0:1&scaling=scale-down-width&t=1cbCHFgXY71PnCpG-1&viewport=455,56,0.14" %}

Versión de teléfono



{% embed url="https://www.figma.com/proto/DDN1a1kKOHmwWRiycK7Jdt/Clase-Dise%C3%B1o-Web?content-scaling=fixed&node-id=46-11335&node-type=canvas&page-id=0:1&scaling=scale-down-width&t=1cbCHFgXY71PnCpG-1&viewport=455,56,0.14" %}

### Contacto

Si tienes alguna pregunta, no dudes en ponerte en contacto con nosotros a través de los siguientes medios:

* **Correo Electrónico:** contacto@ejemplo.com
* **Teléfono:** +34 123 456 789
* **Dirección:** Calle Ejemplo, 123, 28001 Madrid, España
