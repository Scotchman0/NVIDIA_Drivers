# steps for installing CUDA:

1. Ensure that you have a compatible NVIDIA driver setup; either via the automatic selection process, or by choosing your specific nvidia driver stack:
`./NVIDIA-drivers.sh` or `sudo apt install nvidia-driver-470 -y`

2. Follow steps to download the network build of cuda from here: https://developer.nvidia.com/cuda-11.3.0-download-archive - these pull cuda 11.3
~~~
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
~~~

3. Install the specific version of cuda you wish to use:
`sudo apt install cuda-11-3`

4. Note that you may need to pull additional dependencies, so review the apt install messages if it responds with "needs X but will not be installed"
For example, in my installation I needed to also pull relevant drivers to match with the Nvidia-530 driver bundle, which resolved the dependencies.
`sudo apt install cuda-11-3 cuda-runtime-11-3 cuda-drivers-530 libnvidia-extra-530`

5. install the nvidia-cuda-toolkit to use `nvcc` if you don't already have installed:
`sudo apt install nvidia-cuda-toolkit`

6. You may need to reboot your machine to ensure that drivers load properly (optional)

7. Then set your path so that `nvcc` will reference the new cuda build:
`echo "export PATH=/usr/local/cuda-11.3/bin:$PATH" >> ~/.bashrc`

8. Check that things are working properly:
`nvcc --version`
`nvidia-smi`


# Troubleshooting:
- I have had some better success periodically using the RUNFILE option at the cuda download pages because it is self-contained.
You can point your shell (step 6) at the new install the moment it's available
