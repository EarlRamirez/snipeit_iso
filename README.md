# Snipe-IT Custom ISO

Snipe-IT (https://snipeitapp.com/) is the best open source web-based inventory system that I have ever used. 

Spending some time on gitter.im/snipe/snipe-it, it was observed that most of the new comers run into a few challenges when trying to get up and running with Snipe-IT

The goal of this project is to eliminate or limit this challenge by creating a customised ISO where Snipe-IT will be installed without the user having to get their hands dirty.

However, if you don't want the hassel of updates, upgrades and faster turnover to your issues, it is recommended that you use the hosted option, more details can be found here ==> https://snipeitapp.com/hosting.

Below is the list of goals for this project

-------
#### Configure an unattended installation of Snipe-IT using CentOS
The installation uses kickstart to automate the OS installation and run the snipeit.sh script. It also contains snipeit directory with all composer necessary downloads. After the OS installation, you will be forced to change all default credentials, root, snipeit and mariaDB root password. Finally the key will be generated, database will be migrated and you will then get the option to configure email notification or it can be done after by executing /usr/sbin/local/snipeit_mail_setup.sh
##### Create customise scripts and aliases to perform Snipe-IT task
##### Make the OS menu driven for OS and Snipe-IT administration

------- 
This custom ISO is based on CentOS 7 and includes both EPEL and IUS repository.


