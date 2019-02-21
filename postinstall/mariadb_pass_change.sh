#!/bin/bash

mysql_root_pass="snipe_Snipe-IT"


 echo "* Securing MariaDB."
 echo -n " Q. Enter your new MariaDB root password: "
 read -rs mysql_root_pw
	SECURE_MYSQL=$(expect -c "
	set timeout 10
	spawn /bin/mysql_secure_installation
	expect \"Enter current password for root (enter for none):\"
	send \"$mysql_root_pass\r\"
	expect \"Change the root password?\"
	send \"y\r\"
	expect \"New password:\"
	send \"$mysql_root_pw\r\"
	expect \"Re-enter new password:\"
	send \"$mysql_root_pw\r\"
	expect \"Remove anonymous users?\"
	send \"y\r\"
	expect \"Disallow root login remotely?\"
	send \"y\r\"
	expect \"Remove test database and access to it?\"
	send \"y\r\"
	expect \"Reload privilege tables now?\"
	send \"y\r\"
	expect eof
	")
 echo "$SECURE_MYSQL"

