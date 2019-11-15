# NVIDIA_Drivers
A simple bash script for automatic install of the proper nvidia drivers on Debian/ubuntu

This script will perform the following actions on your machine:
1. Check for and perform base updates (sudo apt update && sudo apt upgrade -y)
2. Add the PPA for "ubuntu-drivers" which handles NVIDIA driver installation repositories
3. Run a request to check the hardware of your NVIDIA card
4. Install the recommended driver for that card based on latest data in the PPA
5. Blacklist the NOUVEAU driver baseline for default cards (often will cause nice new GPU's to boot into a graphic error)
6. Recompile the initramfs to include the new drivers and omit the old
7. Prompt you to restart.


I've included an additional script for MOK management - generally you shouldn't need to run this, but if you find that you've enabled secureboot on your machine, and your MOK key wasn't enrolled, you'll have an error initializing your new drivers. the MOK key script just kicks a prompt for you to register your SecureBoot Key and restarts your machine - it'll ask you for a new secureboot password and will create a signature file that will be added to MOK manager after a restart. 

Run that MOK script only if you find after running the NVIDIA_drivers script your machine seems to keep coming up with graphics driver issues or very low resolution.
A good tip off that this is the case, is if during NVIDIA driver installations, it asks you to assign a secureboot passphrase. This means that the files aren't automatically being signed by your secureboot setup key, and they'll fail to initialize on next restart.

#Troubleshooting NVIDIA graphics problems:

Error: you've installed your shiny new GPU, connected it to all the proper power leads, it'll show you the BIOS and get you to the select your OS boot option, but then immediately throws an error about not finding a 0x0000000000.e file and gives you garbage on the display (graphical distorition).

Solution:
1. When the machine boots up, press "E" on the "boot to Ubuntu" prompt. 
2. at the line that begins with "Linux ..." scroll to the end of the line and add "nomodeset"
your line should look a bit like the following: 
> Linux ....... Quiet Splash nomodeset ---
3. press f10 to save your changes (this is temporary and next restart will undo them) - it'll get you into a bare-bones graphics mode which will let you install your drivers and whatever else. 


Error:
While installing your NVIDIA drivers with this script, it asks you for a password for secure boot, and then after you restart, the same Garbage display error comes up, OR, you still get a very low output graphics mode (low resolution).

Solution:
Run the MOK manage script attached and assign a secureboot key (use the same key you used for the nvidia install). Note that secureboot key password does not need to be the same as the login for your admin or local account. (write it down somewhere). 
The MOK script will kick off the MOK enrollment and restart your machine. select ENROLL keys and continue through prompts on blue screen, typing in this secureboot password finally and selecting restart. SECUREBOOT will be enrolled with this key, allowing access to the NVIDIA drivers, and it should restart will a solid resolution that's expected for your monitor. If not, re-run the NVIDIA_drivers install script again and restart. 
