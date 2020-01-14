#!/bin/bash
# @author: 'grufwub'
# @origin: 'https://notbird.site/@grufwub/102423194197582468'
# @source: 'https://pastebin.com/i3dzL8Mu'

debootstrap='DEBOOTSTRAP_DIR=/opt/debootstrap/usr/share/debootstrap /opt/debootstrap/usr/sbin/debootstrap'
debootstrap_url='http://ftp.debian.org/debian/pool/main/d/debootstrap/debootstrap_1.0.115_all.deb'

function install_debootstrap()
{
local curdir tmpdir
echo "Installing debootstrap"
tmpdir=$(mktemp -d)
cd $tmpdir
curl -o debootstrap.deb "$debootstrap_url"
ar x debootstrap.deb
sudo mkdir -p /opt/debootstrap
sudo cp data.tar.gz /opt/debootstrap
curdir=$(pwd)
cd /opt/debootstrap
sudo tar -xf data.tar.gz
sudo rm -f data.tar.gz
cd $curdir
rm -rf $tmpdir
}

function mount_filesystems()
{
sudo echo -n '' # just to ensure we still have sudo
echo -n "Mounting filesystems..."
sudo mount -t proc /proc "$1/proc"
sudo mount -t sysfs /sys "$1/sys"
sudo mount -o bind /dev "$1/dev"
sudo mount -o bind /dev/pts "$1/dev/pts"
echo " Done!"
}

function unmount_filesystems()
{
sudo echo -n '' # just to ensure we still have sudo
echo -n "Unmounting filesystems..."
sudo umount "$1/proc"
sudo umount "$1/sys"
sudo umount "$1/dev/pts"
sudo umount "$1/dev"
echo " Done!"
}

function install_debian()
{
echo "Installing Debian..."
sudo bash -c "$debootstrap --arch amd64 buster '$1' http://ftp.uk.debian.org/debian/"

echo -n "Writing Debian sources file..."
sudo bash -c "cat > '$1/etc/apt/sources.list'" << EOF
deb http://ftp.uk.debian.org/debian/ buster main non-free contrib
deb-src http://ftp.uk.debian.org/debian/ buster main non-free contrib

deb http://security.debian.org/ buster/updates main non-free contrib
deb-src http://security.debian.org/ buster/updates main non-free contrib

deb http://ftp.uk.debian.org/debian/ buster-updates main non-free contrib
deb-src http://ftp.uk.debian.org/debian/ buster-updates main non-free contrib
EOF
echo " Done!"

echo -n "Copying across hostname..."
sudo cp /etc/hostname "$1/etc/hostname"
echo " Done!"

mount_filesystems "$1"

echo "Performing initial package updates within chroot..."
sudo chroot "$1" /bin/bash -c 'apt-get update && apt-get dist-upgrade -y'
sudo chroot "$1" /bin/bash -c 'apt-get install -y locales'
sudo chroot "$1" /bin/bash -c '/usr/sbin/dpkg-reconfigure locales'
sudo chroot "$1" /bin/bash -c 'apt-get install -y nano sudo ncurses-term git curl wget'

echo "Creating group wheel"
sudo chroot "$1" /bin/bash -c "/usr/sbin/groupadd wheel"

echo "Adding group wheel to sudoers"
sudo chroot "$1" /bin/bash -c "echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers"

echo "Creating user: $USER"
sudo chroot "$1" /bin/bash -c "/usr/sbin/useradd -m -g users -G sudo -s /bin/bash $USER"

echo "Please enter a password for $USER..."
sudo chroot "$1" /bin/bash -c "passwd $USER"
echo "Done!"

unmount_filesystems "$1"
}

if [ "`id -u`" -eq 0 ] ; then
    echo "Please do not run this script as root."
    exit 1
fi

if ! wget -V > /dev/null 2>&1 ; then
    echo "Please install wget. Required for debootstrap"
    exit 1
fi

if ! (bash -c "$debootstrap --version" > /dev/null 2>&1) ; then
    install_debootstrap
fi

if [[ "$1" == "" ]] ; then
    echo "Please supply a chroot directory!"
    exit 1
fi

if [[ ! -d "$1" ]] ; then
    echo "Creating directory: $1"
    mkdir -p "$1"
    install_debian "$1"
fi

mount_filesystems "$1"
sudo chroot "$1" /bin/bash -c "su $USER --login"
unmount_filesystems "$1"