#!/bin/bash

# https://www.linuxcapable.com/how-to-install-the-latest-nvidia-graphic-drivers-on-fedora-35-gnome-41/
# The link above is where these instructions were gathered from, the only thing that I am doing is automating it in a bash script
# For faster installation. 

echo "be sure you run this with sudo rights, will necessiate a reboot at the last step and will force updates to your operating system"
echo "please review the code before proceeding - to uninstall these drivers when/if needed - you can run the following line"
echo "$ sudo dnf autoremove akmod-nvidia xorg-x11-drv-nvidia-cuda -y"
echo "The Noveau drivers will be disabled when this script completes (and if you run the above line will be re-enabled automatically)"
echo "press return to begin script"
read dummyfile

#update base OS
dnf upgrade --refresh -y
dnf install dnf-plugins-core -y

#install/activate base-repos:
dnf install \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# refresh DNF
dnf update --refresh

#install the baseline driver set from akmod:
dnf install akmod-nvidia

#install the cuda drivers:
dnf install xorg-x11-drv-nvidia-cuda

echo "script completed, drivers installed - you should reboot your computer to re-initialize, will disable noveau automatically \n"
echo "After reboot, run 'nvidia-smi' to validate nvidia drivers initialized properly"
echo "you can also launch 'nvidia-settings' to review the acess panel options for the GPU"
exit 0
