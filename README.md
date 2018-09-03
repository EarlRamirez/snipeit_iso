## Snipe-IT Custom ISO

[Snipe-IT](https://snipeitapp.com/) is the best open source web-based inventory system that I have ever used. 

Spending some time on [gitter](https://gitter.im/snipe/snipe-it) and [github](https://github.com/snipe/snipe-it/issues), it was observed that most of the newcomers run into a few challenges when trying to get up and running with Snipe-IT

The goal of this project is to eliminate or limit this challenge by creating a customised ISO where Snipe-IT will be installed without the user having to get their hands dirty. 

If you don't want the hassel of updates, upgrades and will like faster turnover to your issues, it is highly recommended that you use the [hosted](https://snipeitapp.com/hosting) option provided by Snipe-IT


-------
### Project Goal

#### Configure an unattended installation of Snipe-IT using CentOS
The installation uses kickstart to automate the OS installation and run a modified version of snipeit.sh script. It also contains snipeit directory with all composer necessary downloads. After the OS installation, you will be forced to change all default credentials root, snipeit and mariaDB root password. The _APP_ key will be generated, database will be migrated and you will then get the option to configure email notification, if you do not wish to configure email notification at this time, it can be done at anytime by executing */usr/sbin/local/snipeit_mail_setup.sh* from the shell.
This ensures that you can have Snipe-IT functional without an internet connection

#### Make the OS menu driven
- Create a menu which will be activated after the user logs on
- Split the menu in two parts, first part will consists of basic OS administration with option to go to the shell and the second part will help you to manage Snipe-IT, e.g. upgrades, clearing the cache, toggling debugging, etc.

------- 
### OS and software versions

The version of OS and software are.
- CentOS 7.5
- PHP 7.2
- Snipe-IT 4.4.1

This custom ISO includes both EPEL and IUS repository; therefore, upgrading the OS and Snipe-IT will be achieved by using the following commands.
- yum -y upgrade
- cd /var/www/html/snipeit/ && sudo -u apache php upgrade.php


To minimise the size of the OS, only the required [packages](https://github.com/EarlRamirez/snipeit_iso/blob/master/included_packages.txt) were used, additional packages _Perl_ and _Python_ are included.

Additionally, a few changes were made from the standard behaviour from a vanilla CentOS, these are
- Changes in firewalld default zone from public to drop
- Restricting root access via ssh
- SSH sessions automatically times out after 15 minutes of being inactive
- Disable unused filesystems
- Disable uncommon protocols
- Harden SSH
- Enforce password policy


-------
### Download OS

The ISO can be downloaded at [Trinipino.org](https://trinipino.org/snipeit/Snipe-IT_x86_64-2-3.iso)


--------
### Installation
Once you have downloaded the ISO mount it to your favourite virtualisation tool, e.g. Vmware, KVM, Virtual Box, etc.

The OS will be installed and configured for you, the server will reboot and perform a few post installation steps, when you are at the login prompt, you will receive the default creadentials, after you have successfully
authenticated, the final script will be executed, this script will ensure that you change the default credentials


When default credentials are reset, the _APP_ key (_php artisan key:generate --force_) will be generated, additionally, the database will be migrated (_php artisan migrate --force_). These are required for Snipe-IT;
therefore, do not cancel this script for a few reasons
- These important processes will not take place
- You will be prompt each time to change the OS credentials (root and snipeit) and MariaDB root password.

---------
### Troubleshooting
During the initial relase of this custom ISO, the _.env.sample_ was modified to remove duplicate **BACKUP_ENV**
this was later updated by upstream. Since upstream pushes this via Git, the upgrade will fail; therefore you will need to do the following.
- git stash
- sudo -u apache php upgrade.php

If you are unable to stash that change, you will need to tell Git who you are; therefore, you will need to use the following commands.
- git config user.email an_email_address
- git config user.name "Your Name"
Then try stashing the changes and you will be able to perform the upgrade.

This issue was resolved on 2 September; therefore, all downloads after this date will not experience this issue.

