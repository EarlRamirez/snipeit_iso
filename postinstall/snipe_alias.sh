#!/bin/bash
# Snipe-IT Alias

snipephp="sudo -u apache php"
clear_config="snipephp artisan config:clear"
clear_cache="snipephp artisan cache:clear"
snipe_upgrade="snipephp upgrade.php"
snipe_backup="snipephp artisan snipeit:backup"
snipe_migrate="snipephp artisan migrate"

