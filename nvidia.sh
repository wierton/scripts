# Run prime-select query to get all possible options. You should see at least nvidia | intel.
# Choose prime-select nvidia
sudo apt-get install linux-{headers,image,image-extra}-$(uname -r) nvidia-cuda-toolkit
sudo prime-select nvidia # important
sudo apt-get install nvidia-driver-430
