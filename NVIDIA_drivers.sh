#!/bin/bash

#This script will add the Ubuntu-targeted NVIDIA drivers PPA, run an update
#And then install the recommended package for this machine. 
#Written by: William Russell for public use.
#11/6/19

#Ensure no pending updates:
apt-get update && apt upgrade -y
sleep 3
clear

#add the PPA
add-apt-repository ppa:graphics-drivers/ppa
sleep 2
clear

#check for new updates:
apt-get update
sleep 2
clear

#scan for drivers:
ubuntu-drivers devices
sleep 5
ubuntu-drivers autoinstall
sleep 5
clear

#blacklist the Nouveau driver so it doesn't initialize:
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sleep 2
cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
sleep 4
clear

#update the kernel to reflect changes:
echo "updating initramfs..."
sleep 3
sudo update-initramfs -u
clear

#end of script output
echo "Script completed - NVIDIA drivers installed"
echo "please restart your machine to initialize correctly"

