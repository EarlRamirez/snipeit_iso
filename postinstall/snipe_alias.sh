# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias clear_config="sudo -u apache php artisan config:clear"
alias clear_cache="sudo -u apache php artisan cache:clear"
alias snipe_upgrade="sudo -u apache php upgrade.php"
alias snipe_backup="sudo -u apache php artisan snipeit:backup"
alias snipe_migrate="sudo -u apache php artisan migrate"

