#!/bin/bash
#supplemental script to resolve common error:
#"Failed to initialize NVML: Driver/library version mismatch"

#This script will unload modules, then attempt to restart the nvidia-smi toolkit to re-load properly


#announce permissions:
echo "this script needs to be run with sudo, if you get errors unmounting, re-run with sudo permissions"
echo "press return to kick-off"
read dummyfile

#get modules:
echo "loaded nvidia modules"
lsmod | grep ^nvidia | awk {'print $1'}

#clear loop:
for mod in $(lsmod | grep ^nvidia | awk {'print $1'}); do echo $mod; rmmod $mod

#check for clear modules before starting services again:
check=$(lsmod | grep ^nvidia)
if [[ $? != 0 ]]; then
  echo "command execution checking for modules with lsmod failed mid-script, clean up may have completed anyway, checking status"
  nvidia-smi
elif [[ $check ]]; then
  echo "modules not entirely removed, may require manual removal."
  echo "here are the running modules, use pkill to stop the pids associated, then re-run"
  lsof /dev/nvidia*
  exit 1
else
  echo "modules removed successfully, restarting nvidia access"
  nvidia-smi
fi
