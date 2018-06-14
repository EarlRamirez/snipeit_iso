#!/bin/bash

echo "Let's change the default credentials for the system users
root and snipeit, while we are at it, we will change the mariadb root password"
echo ""
/bin/passwd
echo ""
echo ""
/bin/passwd snipeit
echo ""
echo "Changing mariaDB root password..."
/usr/local/bin/mariadb_pass_change.sh
echo ""
echo "Almost there! Let us conifgure Snipe-IT to send
email notification, if you wish to perform this
step at another time run snipeit_mail.setup.sh"
/usr/local/bin/snipeit_mail.setup.sh
echo ""
echo "  ***Open http://$ipaddr to login to Snipe-IT.***"
echo ""
echo "Cleaning up"
rm -rf /etc/profile.d/snipeit.sh
echo "* Finished!"
sleep 1

