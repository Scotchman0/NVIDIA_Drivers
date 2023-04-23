#!/bin/bash

#this tool will purge/remove all remnant objects from a failed/bad nvidia driver installation - use with caution, can put your endpoint in an unstable state. DO NOT REBOOT until you've reinstalled a graphics driver

echo "this script must be run with sudo"
echo "press return to start; and you may choose whether to purge/keep packages as they are listed"

for i in $(dpkg -l | grep nvidia | awk {'print $2'}); do echo $i; apt-get --purge remove $i; done

echo "packages removed, you must now reinstall a driver and then run:"
echo "sudo update-initramfs -u"
echo "note further that you *may* wish to run `sudo apt autoremove` but this will purge packages that may be in a pending state *until* you install the next driver."
echo "better to wait and reinstall a driver then see what remains to cleanup"

