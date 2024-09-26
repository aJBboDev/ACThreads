#/bin/sh
#   By @aJBboCydia

rm -rf .theos packages

make clean
make package THEOS_PACKAGE_SCHEME=rootless

sshpass -p "a" ssh root@172.20.10.1 rm -rf /var/mobile/Documents/theosTweaks/*.deb
sshpass -p "a" scp -r packages/*.deb root@172.20.10.1:/var/mobile/Documents/theosTweaks
sshpass -p "a" ssh root@172.20.10.1 dpkg -i /var/mobile/Documents/theosTweaks/*.deb
sshpass -p "a" ssh root@172.20.10.1 killall Threads
