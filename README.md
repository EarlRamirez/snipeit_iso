## Snipe-IT Custom ISO

[Snipe-IT](https://snipeitapp.com/) is the best open source web-based inventory system that I have ever used. 

Spending some time on [gitter](https://gitter.im/snipe/snipe-it) and [github](https://github.com/snipe/snipe-it/issues), it was observed that most of the newcomers run into a few challenges when trying to get up and running with Snipe-IT

The goal of this project is to eliminate or limit this challenge by creating a customised ISO where Snipe-IT will be installed without the user having to get their hands dirty. 

If you don't want the hassel of updates, upgrades and will like faster turnover to your issues, it is highly recommended that you use the [hosted](https://snipeitapp.com/hosting) option provided by Snipe-IT


-------
### Project Goal

#### Configure an unattended installation of Snipe-IT using CentOS
The installation uses kickstart to automate the OS installation and run the snipeit.sh script. It also contains snipeit directory with all composer necessary downloads. After the OS installation, you will be forced to change all default credentials root, snipeit and mariaDB root password. The  app key will be generated, database will be migrated and you will then get the option to configure email notification or it can be done after by executing */usr/sbin/local/snipeit_mail_setup.sh*
This ensures that you are up and running with Snipe-IT without an internet connection

#### Make the OS menu driven
- Create a menu which will be activated after the user logs on
- Split the menu in two parts basic OS administration with option to go to the shell and to manager Snipe-IT

------- 
### CentOS and Snipe-IT Version

This custom ISO is based on CentOS 7.5, Snipe-IT v4.4-1 and includes both EPEL and IUS repository; therefore, upgrading the OS and Snipe-IT will be achieved by using the following commands.
- yum -y upgrade
- cd /var/www/html/snipeit/ && sudo -u apache php upgrade.php

To minimise the size of the OS, only the required packages were used (386) and programming languages _Perl_ and _Python_ is included.

A few changes were made from the standard behaviour from a vanilla CentOS, these are, changes in firewalld default zone from public to drop, restricting root access via ssh and SSH sessions automatically times out after 15 minutes of being inactive

-------
### Download OS

The ISO can be downloaded at [Trinipino.org](https://trinipino.org/snipeit/Snipe-IT_x86_64-2-1.iso)

--------
### Installation
There is not much required to get up and running; however, there is one important thing that needs to be mentioned.
After default credentials are reset, the app key (_php artisan key:generate --force_) will be generated, additionally, the database will migrate (_php artisan migrate --force_). These are required for Snipe-IT;
therefore, do not cancel this script for a few reasons
- These important processes will not take place
- You will be prompt each time to change the OS credentials (root and snipeit) and MariaDB root password.


-------
### TODO
- Script SSL certification
- Harden SSH
- Harden the web server
- Harden the OS
