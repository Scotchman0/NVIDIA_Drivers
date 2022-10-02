driver_mismatch.sh exists to try and automate some of this troubleshooting, but leaving a manual doc page around doesn't hurt 

# ISSUE:
Failed to initialize NVML: Driver/library version mismatch

The error message

    NVML: Driver/library version mismatch

tell us the Nvidia driver kernel module (kmod) have a wrong version, so we should unload this driver, and then load the correct version of kmod
How to do that ?


# RESOLVING:
First, we should know which drivers are loaded.

    lsmod | grep ^nvidia

you may get an output similar to the following:

`module-name` is on the left and `modules that this module depends on` are on the right.

nvidia_uvm            634880  8
nvidia_drm             53248  0
nvidia_modeset        790528  1 nvidia_drm
nvidia              12312576  86 nvidia_modeset,nvidia_uvm


our final goal is to unload `nvidia` mod, so we should unload the modules that `nvidia` depends on first.

~~~
    sudo rmmod nvidia_uvm
    sudo rmmod nvidia_drm
    sudo rmmod nvidia_modeset
~~~

then, unload nvidia

~~~
    sudo rmmod nvidia
~~~

# Troubleshooting

If you get an error like `rmmod: ERROR: Module nvidia is in use`, which indicates that the kernel module is occupied and cannot be stopped, you should kill the process that using the kmod:

    `sudo lsof /dev/nvidia*`
    or
    `sudo lsof | grep nvidia*`
    or 
    `sudo ps -ef | grep nvidia`

and then kill those process, then continue to unload the kmods

confirm you successfully unloaded those kmods with another check:

    `lsmod | grep ^nvidia`

you should get an empty string back. Then just confirm you can load the correct driver by restarting the service via the command interface:

    `nvidia-smi`

If you continue to be unable to reload the module, restart the node or revalidate/re-install your driver set to ensure that there is no older modules being called by newer drivers. This is occasionally due to an install or update where the old versions were not fully purged during a cleanup process.



# It's not working, I can't unload the modules
Try unloading the graphical target by booting to multi-user (this unloads the dependencies on your graphics card and should allow you to remove the modules)
`$ sudo systemctl set-default multi-user.target`
once unloaded, reboot the machine, login at the terminal window (note that you will have no graphical interface, this is expected). Then find and re-run the scripted fix: `driver_mismatch.sh`, or follow steps above again.

To reset your grapical target after you validate that things are working properly with `nvidia-smi` run:
`$ sudo systemctl set-default graphical.target`

If the above still does not work, I highly advise removing your NVIDIA installation - it is probable an older build is still being referenced:

If you've installed via runfile at any point:
`$ sudo /usr/bin/nvidia-uninstall`

otherwise, purge the installation
 ~~~
 sudo apt remove nvidia-* -y
 sudo apt autoremove
 dpkg -l | grep nvidia
 sudo apt remove <remaining-package-names-if-applicable>
 lsmod | grep ^nvidia #there should be none loaded
 ~~~
 
 Then, re-install using the NVIDIA_drivers.sh script
