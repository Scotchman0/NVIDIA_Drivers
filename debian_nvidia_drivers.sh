#!/bin/bash

#This script will add the debian-targeted NVIDIA drivers repo, run an update
#And then install the recommended package for this machine.
#Written by: Will R for public use.
#updated 6/4/2026

#Ensure no pending updates:
sudo apt-get update && apt upgrade -y
sleep 1
clear

OSVERSION=$(cat /etc/os-release | grep VERSION_CODENAME | awk -F "=" {'print $2'})

# check to confirm we can pull the required builds and abort if it does not suggest a version because we'll fail the next step otherwise:
if [[ $(apt-cache policy nvidia-driver nvidia-settings | grep "Candidate" | grep "none") ]]
  then echo "unable to source candidates for required apt install - checking sources.list"
    #see if the required repositories are enabled - we require `contrib` and `non-free` as part of default debian repo sources - if not , abort.
    if [[ ! $(grep -E "contrib" /etc/apt/sources.list | grep -v '^#') ]]
       then cat /etc/apt/sources.list | grep -v '^#'
            echo ""
            echo "----"
            echo "required repository source not enabled: please review /etc/apt/sources.list output above"
            echo "Please update the file /etc/apt/sources.list to include missing components: main contrib non-free non-free-firmware"
            echo "for repositories:"
            echo "deb http://deb.debian.org/debian ${OSVERSION}"
            echo "should look like: deb http://deb.debian.org/debian ${OSVERSION} main contrib non-free non-free-firmware"
            echo ""
            echo "after making this change, run 'apt update' and re-try script"
            exit 1
    fi
fi

#check here as a gate to ensure that we did actually succeed the above verification if statement - there are edge cases and this will ensure
#we actually do have the ability to call packages
apt-cache policy nvidia-driver nvidia-settings | grep "Candidate"
echo "the above output MUST NOT include the word (none) for either entry - if it does - validate that /etc/apt/sources.list includes"
echo "an entry for 'contrib' and 'non-free' for the repository deb http://deb.debian.org/debian ${OSVERSION} <parameters here>"
echo "manually verify the above then press return to continue or ctrl + c to abort"
read waitforreturn

echo "proceeding to install required nividia-detect tool for driver selections"

#install nvidia-detect for selection assist:
sudo apt install nvidia-detect
clear

#call nvidia-detect to list target drivers:
nvidia-detect

echo ""
echo "please review the list of above selections and choose which driver you wish to install for your system."
echo "Example: 'nvidia-driver' or 'nvidia-470xx-driver'"
echo "If you wish to auto-select latest simply press return with no options"
read option
case $option in
  nvidia-driver-* )
          echo "Will update with requested target driver: apt install ${option} nvidia-smi nvidia-settings #to be installed"
          echo "press return to continue"
          read waitforreturn
          sudo apt install ${option} nvidia-smi nvidia-settings -y
          ;;
  * )
          echo "auto selecting default/latest - apt install nvidia-driver nvidia-smi nvidia-settings #to be installed"
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