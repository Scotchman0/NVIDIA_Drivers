#!/bin/bash

#This script will add the debian-targeted NVIDIA drivers repo, run an update
#And then install the recommended package for this machine.
#Written by: William Russell for public use.
#updated 6/3/2026

#Ensure no pending updates:
sudo apt-get update && apt upgrade -y
sleep 1
clear

# check to confirm we can pull the required builds and abort if it does not suggest a version because we'll fail the next step otherwise:
if [[ $(apt-cache-policy nvidia-driver nvidia-settings | grep "Candidate" | grep "none") ]]
  then echo "unable to source candidates for required apt install - checking sources list"
    #see if the required repositories are enabled - we require `contrib` and `non-free` as part of default debian repo sources - if not , abort.
    if [[ ! $(grep "contrib" /etc/apt/sources.list | grep -v '^#') ]]
       then echo "required repository source not enabled: please review /etc/apt/sources.list:"
            cat /etc/apt/sources.list
            echo ""
            echo "Please update the file /etc/apt/sources.list to include missing components: main contrib non-free non-free-firmware"
            echo "for repositories:"
            echo "deb http://deb.debian.org/debian <version>"
            echo "deb-src http://deb.debian.org/debian <version>"
            echo "should look like: deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware"
            echo ""
            echo "after making this change, run 'apt update' and re-try script"
            exit 1
    fi
fi


#install nvidia-detect for selection assist:
sudo apt install nvidia-detect

#call nvidia-detect to list target drivers:
nvidia-detect

echo ""
echo "please review the list of above selections and choose which driver you wish to install for your system."
echo "Example: 'nvidia-driver' or 'nvidia-470xx-driver'"
echo "If you wish to auto-select latest simply press return with no options"
read option
case $option in
  nvidia-driver-* )
          echo "Will update with requested target driver: ${option} along with nvidia-smi and nvidia-settings"
          echo "press return to continue"
          read waitforreturn
          sudo apt install ${option} nvidia-smi nvidia-settings -y
          ;;
  * )
          echo "auto selecting latest"
          echo "press return to continue"
          read waitforreturn
          sudo apt install nvidia-driver nvidia-smi nvidia-settings
          ;;
esac

#update the kernel to reflect changes:
echo "updating initramfs..."
sleep 1
sudo update-initramfs -u
clear

echo "checking nvidia-smi output for validation"
nvidia-smi

#end of script output
echo "Script completed - NVIDIA drivers installed"
echo "please restart your machine to initialize correctly if `nvidia-smi` output did not report driver version"

exit 0
