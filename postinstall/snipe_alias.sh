# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
clear_config="sudo -u apache php artisan config:clear"
clear_cache="sudo -u apache php artisan cache:clear"
snipe_upgrade="sudo -u apache php upgrade.php"
snipe_backup="sudo -u apache php artisan snipeit:backup"
snipe_migrate="sudo -u apache php artisan migrate"

