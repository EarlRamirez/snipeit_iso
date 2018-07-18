#!/bin/bash

SNIPE=/var/www/html/snipeit
SNIPE_USER="sudo -u apache"

if [ -d $SNIPE ] 
then
	cd $SNIPE
	$SNIPE_USER php upgrade.php
else
	echo "$SNIPE cannot be found"
fi
