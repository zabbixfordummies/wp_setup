#!/bin/bash
#
# WordPress activation script
#
# This script will configure Nginx with the domain
# provided by the user and offer the option to set up
# LetsEncrypt as well.
install_dir="/usr/share/nginx/html"
# Enable WordPress on firstlogin
mkdir /usr/share/nginx/html.old
mv /usr/share/nginx/html /usr/share/nginx/html.old
mv /usr/share/nginx/wordpress /usr/share/nginx/html
chown -R nginx:nginx $install_dir
sed -i 's/index.html;/index.php;/g'  /etc/nginx/conf.d/wordpress.conf
#sed -i 's/mkdir /usr/share/nginx/html.old/#mkdir /usr/share/nginx/html.old/g'  /opt/baknet/wp_setup.sh
#sed -i 's/mv /usr/share/nginx/html /usr/share/nginx/html.old/#mv /usr/share/nginx/html /usr/share/nginx/html.old/g'  /opt/baknet/wp_setup.sh
#sed -i 's/mv /usr/share/nginx/html /usr/share/nginx/html.old/#mv /usr/share/nginx/html /usr/share/nginx/html.old/g'  /opt/baknet/wp_setup.sh

#chown -Rf www-data:www-data /var/www/html
echo "Este script ha copiado a la carpeta $install_dir tu instalación de Wordpress"
echo " La que estaba hasta ahora, ahora se encuentra en /usr/share/nginx/html.old"
echo "----------------------------------------------------------------------------"
echo "Esta instalación requiere un nombre de dominio. Si aun no tienes uno, puedes"
echo "cancelar esta instalación presionando Ctrl+C. Este script se ejecutará en el siguiente login"
echo "----------------------------------------------------------------------------"
echo "Entra el nombre de dominio para tu nueva instalación de Wordpress."
echo "(pe. ejemplo.org or test.ejemplo.org) no incluyas www o http/s"
echo "----------------------------------------------------------------------------"
a=0
while [ $a -eq 0 ]
do
 read -p "Dominio/Subdminio: " dom
 if [ -z "$dom" ]
 then
  a=0
  echo "Por favor, proporciona un nombre de dominio valido o subdominio para continuar, para cancelar presiona Ctrl+C"
 else
  a=1
  sed -i 's/localhost;/$dom;/g'  /etc/nginx/conf.d/wordpress.conf
fi
done

service nginx restart

cp /etc/baknet/.bashrc /root

echo -en "\n\n\n"
echo "Siguiente, tienes la opcion de configurar LetsEncrypt (certificado https) para securizar tu nueva web. Antes de hacer esto, asegurate que tienes tu dominio o subdominio apuntando a la ip de este servidor. Igualmente puedes ejecutar mas tarde certbot de LetsEncrypt con el comando 'certbot --nginx'"
echo -en "\n\n\n"
 read -p "Quieres usar LetsEncrypt (certbot) para configurar SSL (https) para tu nueva web? (s/n): " sn
    case $sn in
        [Ss]* ) certbot --nginx; echo "Wordpress se ha habilitado en https://$dom  Por favor abre esta URL en tu explorador para continuar con la configuración de tu nueva web.";break;;
        [Nn]* ) echo "WordPress se ha habilitado en http://$dom  Por favor abre esta URL en tu explorador para continuar con la configuración de tu nueva web.";exit;;
        * ) echo "Contesta s o n.";;
    esac
