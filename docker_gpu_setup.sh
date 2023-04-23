#!/bin/bash
#This script is designed to ensure that the relevant runtime files are in place
#for docker to engage your GPUs and allow containerized access for training runs
#Run this script to set up docker (will restart docker service)

#see also this resource page: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html


#the below is largely pulled from the following page and recompiled here as a one-shot script for easy installation with some additional comments for better detail breakdown:

#https://collabnix.com/introducing-new-docker-cli-api-support-for-nvidia-gpus-under-docker-engine-19-03-0-beta-release/

##pulls GPG key, adds it to your key files, sets 
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  sudo apt-key add -

#sets variable for your local distribution:
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

#pulls the latest nvidia-container-runtime from nvidia for your build, and pipes it to a sources file for installation:
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

#updates with latest sources:
sudo apt-get update

#install the runtime now that apt is updated:
apt-get install nvidia-container-runtime

#check that the runtime is installed, otherwise fail with error:
if which nvidia-container-runtime-hook >/dev/null; then
  echo "container-runtime found, continuing"
else
  echo "runtime failed, did you run this script with sudo?"
  exit 1
fi

#restart docker service
systemctl restart docker

#run a local check that docker is capable of communicating with GPUS
#should the same output that `nvidia-smi` on the host runs
docker run -it --rm --gpus all ubuntu nvidia-smi

#wrap script
echo "you should see the successful output from `nvidia-smi` run above from within a container"



