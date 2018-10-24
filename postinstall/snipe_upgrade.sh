#!/bin/bash

# This script is used to automatically update Snipe-IT weekly

SNIPE=/var/www/html/snipeit
SNIPE_USER="sudo -u apache"

if [ -d $SNIPE ] 
then
	cd $SNIPE
	$SNIPE_USER php upgrade.php >> /dev/null 2>&1
else
	echo "$SNIPE cannot be found"
fi
