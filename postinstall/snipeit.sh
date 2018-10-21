#!/bin/bash

ipaddr="$(ip -o -4 addr show dev eth0 | sed 's/.* inet \([^/]*\).*/\1/')"

echo "Let's change the default credentials for the system users
root and snipeit, while we are at it, we will change the mariadb root password"
sleep 5
echo ""
/bin/passwd
echo ""
echo ""
/bin/passwd snipeit
echo ""
echo "Changing mariaDB root password..."
/usr/local/bin/mariadb_pass_change.sh
clear
echo ""
echo "Almost there! Let us conifgure Snipe-IT to send
email notification, if you wish to perform this
step at another time run snipeit_mail.setup.sh"
/usr/local/bin/snipeit_mail.setup.sh
echo ""
echo "Final Snipe-IT Configuration"
# Added key generation and DB migration here
# because with systemd, there is no order and
# the DB is getting started after the script
# is executed
cd /var/www/html/snipeit/
php artisan key:generate --force
php artisan migrate --force
clear
echo ""
echo " Point your browser to http://$ipaddr 
to complete Snipe-IT final set-up to start enjoying Snipe-IT"
echo ""
echo "Final clean up"
rm -rf /etc/issue
rm -rf /etc/issue.net
rm -rf /root/rc.local*
cp /root/issue /etc/issue
mv /root/issue /etc/issue.net
rm -rf /etc/profile.d/snipeit.sh
systemctl stop rc-local
systemctl disable rc-local
echo ""
echo "rebooting....."
shutdown -r now
sleep 1

