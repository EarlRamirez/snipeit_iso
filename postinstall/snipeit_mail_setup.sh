#!/bin/bash

webdir="/var/www/html"
name="snipeit"

setupmail=default
until [[ $setupmail == "yes" ]] || [[ $setupmail == "no" ]]; do
echo -n "  Q. Do you want to configure mail server settings? (y/n) "
read -r setupmail

case $setupmail in
    [yY] | [yY][Ee][Ss] )
        echo -n "  Outgoing mailserver address:"
        read -r mailhost
        sed -i 's,^\(MAIL_HOST=\).*,\1'$mailhost',' "$webdir/$name/.env"

        echo -n "  Server port number:"
        read -r mailport
        sed -i 's,^\(MAIL_PORT=\).*,\1'$mailport',' "$webdir/$name/.env"

        echo -n "  Username:"
        read -r mailusername
        sed -i 's,^\(MAIL_USERNAME=\).*,\1'$mailusername',' "$webdir/$name/.env"

        echo -n "  Password:"
        read -rs mailpassword
        sed -i 's,^\(MAIL_PASSWORD=\).*,\1'$mailpassword',' "$webdir/$name/.env"

        echo -n "  Encryption(null/TLS/SSL):"
        read -r mailencryption
        sed -i 's,^\(MAIL_ENCRYPTION=\).*,\1'$mailencryption',' "$webdir/$name/.env"

        echo -n "  From address:"
        read -r mailfromaddr
        sed -i 's,^\(MAIL_FROM_ADDR=\).*,\1'$mailfromaddr',' "$webdir/$name/.env"

        echo -n "  From name:"
        read -r mailfromname
        sed -i 's,^\(MAIL_FROM_NAME=\).*,\1'$mailfromname',' "$webdir/$name/.env"

        echo -n "  Reply to address:"
        read -r mailreplytoaddr
        sed -i 's,^\(MAIL_REPLYTO_ADDR=\).*,\1'$mailreplytoaddr',' "$webdir/$name/.env"

        echo -n "  Reply to name:"
        read -r mailreplytoname
        sed -i 's,^\(MAIL_REPLYTO_NAME=\).*,\1'$mailreplytoname',' "$webdir/$name/.env"
        setupmail="yes"
        ;;
    [nN] | [n|N][O|o] )
        setupmail="no"
        ;;
    *)  echo "  Invalid answer. Please type y or n"
        ;;
esac
# Clear configuration for the changes to take effect
done; cd /var/www/html/snipeit/ && sudo -u apache php artisan config:clear
