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
#### Create customise scripts and aliases to perform Snipe-IT task
#### Make the OS menu driven for OS and Snipe-IT administration

------- 
### Linux Distribution Used

This custom ISO is based on CentOS 7 and includes both EPEL and IUS repository; therefore, upgrading the OS and Snipe-IT will be achieved by using the following commands.
To minimise the size of the OS, only the required packages were used (386) and programming languages _Perl_ and _Python_ is included

- yum -y upgrade
- cd /var/www/html/snipeit/ && sudo -u apache php upgrade.php

A few changes were made from the standard behaviour from a vanilla CentOS, these are, changes in firewalld default zone from public to drop, restricting root access via ssh and SSH sessions automatically times out after 15 minutes of being inactive

-------
### Download OS

The ISO can be downloaded at [Trinipino.org](https://trinipino.org/snipeit/Snipe-IT_x86_64-2-1.iso)

-------
### TODO
- Script SSL certification
- Harden SSH
- Harden the web server
- Harden the OS
