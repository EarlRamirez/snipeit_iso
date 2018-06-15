#!/bin/bash

# Create custom ISO

genisoimage -untranslated-filenames \
-V "CentOS 7 x86_64" \
-A "CentOS 7 x86_64" \
-o Snipe-IT_x86_64-2-1.iso \
-joliet-long \
-b isolinux/isolinux.bin \
-c isolinux/boot.cat \
-no-emul-boot \
-boot-load-size 4 \
-boot-info-table \
-no-emul-boot \
-R -J -v -T \
~/dev/projects/snipeit-iso

sleep 3

# Allow the ISO to boot from USB
sudo isohybrid Snipe-IT_x86_64-2-1.iso

# Permit integrity checking
sudo implantisomd5 Snipe-IT_x86_64-2-1.iso