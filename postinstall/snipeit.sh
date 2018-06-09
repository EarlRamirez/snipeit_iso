# Install and configure Snipe-IT

#!/bin/bash
######################################################
#           Snipe-It Install Script                  #
#          Script created by Mike Tucker             #
#            mtucker6784@gmail.com                   #
# This script is just to help streamline the         #
# install process for Debian and CentOS              #
# based distributions. I assume you will be          #
# installing as a subdomain on a fresh OS install.   #
#                                                    #
# Feel free to modify, but please give               #
# credit where it's due. Thanks!                     #
######################################################

# ensure running as root
if [ "$(id -u)" != "0" ]; then
    #Debian doesnt have sudo if root has a password.
    if ! hash sudo 2>/dev/null; then
        exec su -c "$0" "$@"
    else
        exec sudo "$0" "$@"
    fi
fi

#First things first, let's set some variables and find our distro.
clear

name="snipeit"
verbose="false"
hostname="$(hostname)"
fqdn="$(hostname --fqdn)"
hosts=/etc/hosts
mysqluserpw="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16; echo)"
#TODO automate root password or add it to menu 
mysql_root_pass="snipe_Snipe-IT"

spin[0]="-"
spin[1]="\\"
spin[2]="|"
spin[3]="/"

# updated access.log to be inside of httpd/ to prevent SELinux errors.
setvhcentos () {
    apachefile=/etc/httpd/conf.d/$name.conf
    {
        echo "<VirtualHost *:80>"
        echo "ServerAdmin webmaster@localhost"
        echo "    <Directory $webdir/$name/public>"
        echo "        Allow From All"
        echo "        AllowOverride All"
        echo "        Options +Indexes"
        echo "   </Directory>"
        echo "    DocumentRoot $webdir/$name/public"
        echo "    ServerName $fqdn"
        echo "        ErrorLog /var/log/httpd/snipeIT.error.log"
        echo "        CustomLog /var/log/httpd/access.log combined"
        echo "</VirtualHost>"
    } >> "$apachefile"
}

log () {
    if [ "$verbose" = true ]; then
        eval "$@"
    else
        eval "$@" |& tee -a /var/log/snipeit-install.log >/dev/null 2>&1
    fi
}

installsnipeit () {
    echo "* Cloning Snipe-IT from github to the web directory."
    log "git clone https://github.com/snipe/snipe-it $webdir/$name"

    echo "* Configuring .env file."
    cp "$webdir/$name/.env.example" "$webdir/$name/.env"

    sed -i '1 i\#Created By Snipe-it Installer' "$webdir/$name/.env"
    sed -i 's,^\(APP_TIMEZONE=\).*,\1'$tzone',' "$webdir/$name/.env"
    sed -i 's,^\(DB_HOST=\).*,\1'localhost',' "$webdir/$name/.env"
    sed -i 's,^\(DB_DATABASE=\).*,\1'snipeit',' "$webdir/$name/.env"
    sed -i 's,^\(DB_USERNAME=\).*,\1'snipeit',' "$webdir/$name/.env"
    sed -i 's,^\(DB_PASSWORD=\).*,\1'$mysqluserpw',' "$webdir/$name/.env"
    sed -i 's,^\(APP_URL=\).*,\1'http://$fqdn',' "$webdir/$name/.env"

    echo "* Installing and running composer."
    cd "$webdir/$name/"
    curl -sS https://getcomposer.org/installer | php
    # Added composer_process_timeout variable for slow internet connections
    COMPOSER_PROCESS_TIMEOUT=6000 php composer.phar install --no-dev --prefer-source

    echo "* Setting permissions."
    for chmod_dir in "$webdir/$name/storage" "$webdir/$name/storage/private_uploads" "$webdir/$name/public/uploads"; do
        chmod -R 775 "$chmod_dir"
    done

    chown -R "$ownergroup" "$webdir/$name"

    echo "* Generating the application key."
    log "php artisan key:generate --force"

    echo "* Artisan Migrate."
    log "php artisan migrate --force"

    echo "* Creating scheduler cron."
    (crontab -l ; echo "* * * * * /usr/bin/php $webdir/$name/artisan schedule:run >> /dev/null 2>&1") | crontab -
}

isinstalled () {
    if yum list installed "$@" >/dev/null 2>&1; then
        true
    else
        false
    fi
}

isdnfinstalled () {
    if dnf list installed "$@" >/dev/null 2>&1; then
        true
    else
        false
    fi
}
#TODO:  Duplicate with kickstart need to eliminate one 
openfirewalld () {
    if [ "$(firewall-cmd --state)" == "running" ]; then
        echo "* Configuring firewall to allow HTTP traffic only."
        log "firewall-cmd --zone=public --add-service={http,https,ssh} --permanent"
        log "firewall-cmd --reload"
    fi
}

if [ -f /etc/os-release ]; then
    distro="$(. /etc/os-release && echo $ID)"
    version="$(. /etc/os-release && echo $VERSION_ID)"
    #Order is important here.  If /etc/os-release and /etc/centos-release exist, we're on centos 7.
    #If only /etc/centos-release exist, we're on centos6(or earlier).  Centos-release is less parsable,
    #so lets assume that it's version 6 (Plus, who would be doing a new install of anything on centos5 at this point..)
    #/etc/os-release also properly detects fedora
elif [ -f /etc/centos-release ]; then
    distro="Centos"
    version="6"
else
    distro="unsupported"
fi

echo "
       _____       _                  __________
      / ___/____  (_)___  ___        /  _/_  __/
      \__ \/ __ \/ / __ \/ _ \______ / /  / /
     ___/ / / / / / /_/ /  __/_____// /  / /
    /____/_/ /_/_/ .___/\___/     /___/ /_/
                /_/
"

echo ""
echo "  Welcome to Snipe-IT Inventory Installer for CentOS, Fedora, Debian and Ubuntu!"
echo "  Many thanks to @snipe (mastermind behind Snipe-IT) "
echo "  Mike Tucker (creator of this script) and the Snipe-IT community"
echo ""
shopt -s nocasematch
case $distro in
    *centos*|*redhat*|*ol*|*rhel*)
        echo "  The installer has detected $distro version $version."
        distro=centos
        ;;
    *fedora*)
        echo "  The installer has detected $distro version $version."
        distro=fedora
        ;;
    *)
        echo "  The installer was unable to determine your OS. Exiting for safety."
        exit
        ;;
esac
shopt -u nocasematch
fqdn="$(hostname --fqdn)"

echo "     Setting to $fqdn"
echo ""


#TODO: Lets not install snipeit application under root

	   if [[ "$version" =~ ^7 ]]; then
        #####################################  Install for CentOS/Redhat 7  ##############################################
        webdir=/var/www/html
        ownergroup=apache:apache
        tzone=$(timedatectl | gawk -F'[: ]' ' $9 ~ /zone/ {print $11}');

        echo "* Adding IUS, epel-release and MariaDB repositories."
        log "yum -y install wget epel-release"
        log "yum -y install https://centos7.iuscommunity.org/ius-release.rpm"
        log "rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY"

        echo "* Installing Apache httpd, PHP, MariaDB and other requirements."
        PACKAGES="httpd mariadb-server git expect unzip php71u php71u-mysqlnd php71u-bcmath php71u-process php71u-cli php71u-common php71u-embedded php71u-gd php71u-mbstring php71u-mcrypt php71u-ldap php71u-json php71u-simplexml"

        for p in $PACKAGES; do
            if isinstalled "$p"; then
                echo "  * $p already installed"
            else
                echo "  * Installing $p ... "
                log "yum -y install $p"
            fi
        done;

        echo "* Setting MariaDB to start on boot and starting MariaDB."
        log "systemctl enable mariadb.service"
        log "systemctl start mariadb.service"
		# Automated configuration for securing MySQL/MariaDB		
		echo "* Securing MariaDB."
		SECURE_MYSQL=$(expect -c "
		set timeout 10
		spawn /bin/mysql_secure_installation
		expect \"Enter current password for root (enter for none):\"
		send \"$mysql_root\r\"
		expect \"Change the root password?\"
		send \"y\r\"
		expect \"New password:\"
		send \"$mysql_root_pass\r\"
		expect \"Re-enter new password:\"
		send \"$mysql_root_pass\r\"
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
		echo ""

        echo "* Creating MariaDB Database/User."
        #echo "* Please Input your MariaDB root password "
        mysql -u root --password=$mysql_root_pass --execute="CREATE DATABASE snipeit;GRANT ALL PRIVILEGES ON snipeit.* TO snipeit@localhost IDENTIFIED BY '$mysqluserpw';"

        #TODO make sure the apachefile doesnt exist isnt already in there
        echo "* Creating the new virtual host in Apache."
        setvhcentos

        #TODO make sure this isnt already in there
        echo "* Setting up hosts file."
        echo >> $hosts "127.0.0.1 $hostname $fqdn"
		
		echo "* Installing Snipe-IT"	
        installsnipeit

        #open the firewall for HTTP traffic only
        openfirewalld

        #Check if SELinux is enforcing
        if [ "$(getenforce)" == "Enforcing" ]; then
            echo "* Configuring SELinux."
            #Required for ldap integration
            setsebool -P httpd_can_connect_ldap on
            setsebool -P httpd_can_sendmail on
            #Sets SELinux context type so that scripts running in the web server process are allowed read/write access
            semanage fcontext -a -t httpd_sys_rw_content_t "$webdir/$name(/.*)?"
			restorecon -R $webdir/$name
        fi

        echo "* Setting Apache httpd to start on boot and starting service."
        log "systemctl enable httpd.service"
        log "systemctl restart httpd.service"

    else
        echo "Unsupported CentOS version. Version found: $version"
        exit 1
    fi

echo ""
echo "  ***Open http://$fqdn to login to Snipe-IT.***"
echo ""
echo ""
echo "* Cleaning up..."
rm -f /root/snipeit.sh
rm -f /root/snipeit.sh~
rm -rf /root/pre_issue
rm -rf /root/pre_issue~
rm -rf /root/snipeit_mail_setup.sh
rm -rf /etc/issue
rm -rf /etc/issue.net
mv /etc/issue-backup /etc/issue
mv /etc/issue.net-backup /etc/issue.net
rm -rf /etc/profile.d/snipeit.sh
echo ""
echo ""
echo "It is higly recommended that you change the root default password"
echo "Let us change the root password"
/bin/passwd
echo ""
echo ""
echo "Since we are here, let us change snipeit password"
/bin/passwd snipeit
/bin/clear
echo "Almost there! Let us conifgure Snipe-IT to send
	  email notification, if you wish to perform this
	  this step at another time run snipeit_mail.setup.sh"
/usr/local/bin/snipeit_mail.setup.sh
echo "* Finished!"
sleep 1

