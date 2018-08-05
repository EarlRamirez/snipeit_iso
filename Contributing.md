## Contributing to the Project
If you will like to contribute to this project or any other projects on Github you can use this guidelines

### Preparing your environment

#### Prerequisites
- CentOS 7 distribution DVD
- geniso package
- virtual environment (vmware, KVM, VirtualBox)
- text editor (vim, gedit, nano)
- kickstart configuration
- createrepo package

#### Create workspace
- mkdir ~/workspace
- sudo mount ~/Downloads/CentOS-7-x86_64-DVD-1804.iso /mnt/
- cp /mnt/* ~/workspace

Clean up the Packages directory located in ~/workspace/Packeges and keep only the packeages that are listed in
**included_packages.txt**. 

Moify ISO config and update repodate
- vim ~/workspace/isolinux/isolinux.cfg (update the lines that states **append** to inclunde the ks.cfg
_append initrd=initrd.img inst.repo=cdrom ks=cdrom:/ks.cfg net.ifnames=0 biosdevname=0_
- createrepo -g ~/workspace/repodata/*comps.xml . --update

#### Cloning Repository
Navigate to your workspace and clone the _dev_ branch into your workspace, due to the size of the many directories I had to
exclude them from Github.

- mkdir ~/workspace
- cd ~/workspace
- git clone -b dev https://github.com/EarlRamirez/snipeit_iso.git

#### Creating Branch and Submitting Pull Request (PR)
Navigate to git repository and create the branch, as a rule of thumb you will create the branch based on what you 
intend to fix, e.g. update_selinux_labels
- cd ~/workspace/snipeit_iso
- git branch update_selinux_label
- git checkout update_selinux_label

Make your desired changes, commit and push the branch to your fork so that you can create the pull request.
- git commit -am "Updated SELinux Labels"
- git push origin update_selinux_label

#### Updating Your Fork


