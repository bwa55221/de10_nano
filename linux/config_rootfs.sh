#!/bin/bash

cd $DEWD

sudo cp /usr/bin/qemu-arm-static rootfs/usr/bin

sudo chroot rootfs /usr/bin/qemu-arm-static /bin/bash  -x << 'EOF'
su -

# this only needs to be done once, after done, deboostrap directory is deleted
#/deboostrap/debootstrap --second-stage

# set default password
passwd
root
root

echo "updating fstab file"
echo 'none		/tmp	tmpfs	defaults,noatime,mode=1777	0	0' > /etc/fstab
echo '/dev/mmcblk0p2	/	ext4	defaults	0	1' >> /etc/fstab

echo "enabling serial console"
systemctl enable serial-getty@ttyS0.service

echo "enabling ethernet interface"
echo 'auto lo end0' > /etc/network/interfaces
echo 'iface lo inet loopback' >> /etc/network/interfaces
echo 'allow-hotplug end0' >> /etc/network/interfaces
# echo 'iface end0 inet dhcp' >> /etc/network/interfaces
echo 'iface end0 inet static' >> etc/network/interfaces
echo '  address 192.168.1.19/24' >> etc/network/interfaces

echo "installing open ssh server"
apt install openssh-server -y
echo "enabling root login"
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

echo "installing additional packages"
apt install haveged -y
apt install net-tools build-essential device-tree-compiler -y

echo "updating device hostname to: de10-nano"
echo "de10-nano" > /etc/hostname

# echo "Override network timeout to 5 seconds only"
# touch /etc/systemd/system/networking.service.d/override.conf
# echo "TimeoutStartSec=5sec" > /etc/systemd/system/networking.service.d/override.conf

# generate ssh key-pair
ssh-keygen
echo ""
echo ""
echo ""

echo "cleaning up"
apt clean
rm /usr/bin/qemu-arm-static


EOF

