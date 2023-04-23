#!/bin/bash
echo "use with caution, this script will make changes in a broad-strokes kind of way. Use only if absolutely necessary"
echo "This script is going to ask if you're sure, only proceed (by pressing enter) if you've read through what this script does"
echo "note also that this script requires sudo to succeed, and will fail if you've run this without adequate permissions"
echo "commands that are going to be run are: 'apt purge nvidia-*' 'apt autoremove' 'dpkg -l | grep nvidia' 'apt-get --purge remove <dpkg-name>'"
echo "press enter to proceed, otherwise press ctrl+c to abort"
read go_opt
echo "proceeding with script; Would you like to allow the script to attempt to [a]utomatically remove elements (a|A) or would you prefer to [s]elect what to remove? (S|s)
case $option in
    a|A) clear
      echo "proceeding with cleanup"
      apt purge nvidia-* -y
      apt autoremove -y
      for i in $(dpkg -l | grep nvidia | awk {'print $2'}); do echo $i; apt-get --purge remove $i -y; done
      echo "all nvidia elements are now removed - DO NOT REBOOT YOUR COMPUTER"
      echo "you must proceed to INSTALL a graphical driver next, please now run the NVIDIA_drivers.sh script to install drivers"
      echo "failure to install drivers at this stage may result in an unstable system configuration/no GUI on next boot"
      echo "if you intend to boot to CLI only for additional debugging, run: $ sudo systemctl set-default multi-user.target"
      exit 0
     s|S|) clear
      echo "Proceeding with manual removal option, please confirm y/n at all prompts to clean up"
      echo "commands that are going to be run are: 'apt purge nvidia-*' 'apt autoremove' 'dpkg -l | grep nvidia' 'apt-get --purge remove <dpkg-name>'"
      echo "if you abort mid-stream for any reason, you can run the above manually instead to finish up cleanup"
      apt purge nvidia-*
      apt autoremove
      for i in $(dpkg -l | grep nvidia | awk {'print $2'}); do echo $i; apt-get --purge remove $i; done
      echo "all nvidia elements are now removed - DO NOT REBOOT YOUR COMPUTER"
      echo "you must proceed to INSTALL a graphical driver next, please now run the NVIDIA_drivers.sh script to install drivers"
      echo "failure to install drivers at this stage may result in an unstable system configuration/no GUI on next boot"
      echo "if you intend to boot to CLI only for additional debugging, run: $ sudo systemctl set-default multi-user.target"
      exit 0
     *) clear
      echo "unexpected answer provided, exiting out"
      exit 1
esac
echo "cleanup completed, please ensure you re-install a graphics driver next BEFORE rebooting"
exit 0
      
      
    
