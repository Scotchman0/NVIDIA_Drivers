# NVIDIA_Drivers
A simple bash script for automatic install of the proper nvidia drivers on Debian/ubuntu

# How to use this repository:
1. Clone this repo: `git clone https://github.com/Scotchman0/NVIDIA_Drivers/`
2. Enter the directory: `cd NVIDIA_Drivers`
3. Run the install script: `sudo ./NVIDIA_drivers.sh` for ubuntu/deb/apt environments, or `sudo ./nvidia_driver_rhel.sh` for rhel/fedora/dnf/yum environments.
4. Reboot your machine when prompted to re-initialize your platform with the latest driver available for your host.


# The NVIDIA_drivers script will perform the following actions on your machine:
1. Check for and perform base updates (sudo apt update && sudo apt upgrade -y)
2. Add the PPA for "ubuntu-drivers" which handles NVIDIA driver installation repositories
3. Run a request to check the hardware of your NVIDIA card
4. Prompt for your selection of driver (or pressing return will select the recommended one)
5. Blacklist the NOUVEAU driver baseline for default cards (often will cause nice new GPU's to boot into a graphic error)
6. Recompile the initramfs to include the new drivers and omit the old
7. test with `nvidia-smi` for driver access, and then prompt you to restart


# Other Scripts and what they do:

- remove_tool.sh: Removes any and all `nvidia` associated packages with a for-loop running through `dpkg -l`. Very helpful for driver version rollbacks. You should basically be able to just run this and remove nvidia packages, then change to an earlier driver version if you find that a newer driver breaks your setup.

- `purge_nvidia.sh` A much more involved big undo script: 
[[Currently only works on ubuntu/deb/apt environments; calls dpkg/apt purge.]]
This script will completely remove and unload modules/drivers and associated libraries that are neccessary for nvidia to operate. Generally, you will want to run this ONLY if you are unable to figure out what else is stuck on your computer preventing the proper execution of nvidia drivers, but it generally will un-stick your issue if it's because there's a leftover package somewhere that hasn't been properly removed before reinstallation. This is more heavy-handed than `remove_tool.sh` but it ought to cure what ails the system if you are really in a bind. DO NOT FORGET TO REINSTALL A DRIVER afterwards (re-run `NVIDIA_drivers.sh` -- unless you want to debug further in multi-user.target instead of graphical.target, which is fine). It's best to run this from multi-user or secondary TTY session to avoid removal of gpu driver being hung because it is in use by the desktop/gui also.

- `docker_gpu_setup.sh`: This script will place the `nvidia-container-runtime-toolkit` and `nvidia-container-runtime-hook` packages to ensure that docker can communicate with your GPUS. Run this script to enable containerized GPU passthrough for training runs

- `install_cuda.md`: This is steps for installing CUDA library on your machine; not scripted because I assume you'll have particular requirements for which build you need, but should be self-explanatory

- `driver_mismatch.sh` A script for Driver mismatch to address the `NVML: Driver/library version mismatch` error:
Run this script if you find that the above error messages are presented after driver installation. (Note that a reboot should also sufficiently resolve this problem, so start there first).

- `MOK_Enroll.sh` A MOK management script: 
generally you shouldn't need to run this, but if you find that you've enabled secureboot on your machine, and your MOK key wasn't enrolled, you'll have an error initializing your new drivers. the MOK key script just kicks a prompt for you to register your SecureBoot Key and restarts your machine - it'll ask you for a new secureboot password and will create a signature file that will be added to MOK manager after a restart. Run that MOK script only if you find after running the NVIDIA_drivers script your machine seems to keep coming up with graphics driver issues or very low resolution.



# GENERAL Troubleshooting NVIDIA graphics problems:
- See `/help/commonIissues.md` for some additional support options. 

- Error: you've installed your shiny new GPU, connected it to all the proper power leads, it'll show you the BIOS and get you to the select your OS boot option, but then immediately throws an error about not finding a 0x0000000000.e file and gives you garbage on the display (graphical distorition).

- Solution:
1. When the machine boots up, press "E" on the "boot to Ubuntu" prompt. 
2. at the line that begins with "Linux ..." scroll to the end of the line and add "nomodeset"
your line should look a bit like the following: 
> Linux ....... Quiet Splash nomodeset ---
3. press f10 to save your changes (this is temporary and next restart will undo them) - it'll get you into a bare-bones graphics mode which will let you install your drivers and whatever else. 


- Error:
While installing your NVIDIA drivers with this script, it asks you for a password for secure boot, and then after you restart, the same Garbage display error comes up, OR, you still get a very low output graphics mode (low resolution).

- Solution:
Run the MOK manage script attached and assign a secureboot key (use the same key you used for the nvidia install). Note that secureboot key password does not need to be the same as the login for your admin or local account. (write it down somewhere). 
The MOK script will kick off the MOK enrollment and restart your machine. select ENROLL keys and continue through prompts on blue screen, typing in this secureboot password finally and selecting restart. SECUREBOOT will be enrolled with this key, allowing access to the NVIDIA drivers, and it should restart will a solid resolution that's expected for your monitor. If not, re-run the NVIDIA_drivers install script again and restart. 


# Getting more information:
to list what drivers are recommended for your build:
`ubuntu-drivers devices | grep recommended`

It will return the recommended video driver for your machine.

If ubuntu-drivers is not found, run the following command in terminal to install it:

`sudo apt-get install ubuntu-drivers-common`
