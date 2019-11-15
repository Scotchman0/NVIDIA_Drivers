#!\bin\bash
#Quick script written by Will Russell for MOK enrollment kickoff on secureboot
#enabled linux systems - debian/Ubuntu based OS.
#SecureBoot has been enabled but for some reason your key didn't get cached
#Generally affects initializable drivers like NVIDIA GPU and other
#Load at boot system services that need a signature.

#disable secureboot in shim-signed:
echo "This script will ask for a password momentarily - please assign"
echo "the same key that you intend to enroll as your secureboot passphrase"
sleep 5

sudo mokutil --disable-validation

sleep 5
echo "Key captured, Restarting system in 10 seconds"
sleep 10
sudo shutdown -r now

