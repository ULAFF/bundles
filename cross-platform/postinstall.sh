apt-get update
# The non-root user that will be created. By vagrant conventions, this should
# be `"vagrant"`.
account="vagrant"

# Enable truly non interactive apt-get installs
export DEBIAN_FRONTEND=noninteractive

# Determine the platform (i.e. Debian or Ubuntu) and platform version
platform="$(lsb_release -i -s)"
platform_version="$(lsb_release -s -r)"

# Run the script in debug mode
set -x

### Customize Sudoers

# The main user (`vagrant` in our case) needs to have **password-less** sudo
# access as described in the Vagrant base box
# [documentation](http://vagrantup.com/docs/base_boxes.html#setup_permissions).
# This user belongs to the `admin`/`sudo` group, so we'll change that line.
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
case "$platform" in
  Debian)
      sed -i -e 's/%sudo ALL=(ALL) ALL/%sudo ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
    ;;
  Ubuntu)
    groupadd -r admin || true
    usermod -a -G admin $account
    sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
    ;;
esac

### Other setup

# Set the LC_CTYPE so that auto-completion works and such.
echo "LC_ALL=\"en_US\"" > /etc/default/locale

### Vagrant SSH Keys

# Since Vagrant only supports key-based authentication for SSH, we must
# set up the vagrant user to use key-based authentication. We can get the
# public key used by the Vagrant gem directly from its Github repository.
vssh="/home/${account}/.ssh"
mkdir -p $vssh
chmod 700 $vssh
(cd $vssh &&
  wget --no-check-certificate \
    'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' \
    -O $vssh/authorized_keys)
chmod 0600 $vssh/authorized_keys
chown -R ${account}:vagrant $vssh
unset vssh

### VirtualBox Guest Additions

# The netboot installs the VirtualBox support (old) so we have to remove it
apt-get -y remove virtualbox-ose-guest-dkms
apt-get -y remove virtualbox-ose-guest-utils

### Misc. Tweaks

# Install NFS client
apt-get -y install nfs-common

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Customize the message of the day
case "$platform" in
  Debian)
    echo 'Welcome to your Vagrant-built virtual machine.' > /var/run/motd
    ;;
  Ubuntu)
    echo 'Welcome to your Vagrant-build virtual machine.' > /etc/motd.tail
    ;;
esac

# Record when the basebox was built
date > /etc/vagrant_box_build_time

# Networking - This works around issue #391

cat <<EOF > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Make sure eth0 is working. This works around Vagrant issue #391
dhclient eth0

exit 0
EOF

### Clean up

# Remove the build tools to keep things pristine
apt-get -y remove build-essential make curl git-core

apt-get -y autoremove
apt-get -y clean

# Removing leftover leases and persistent rules
rm -f /var/lib/dhcp3/*

# Make sure Udev doesn't block our network, see: http://6.ptmc.org/?p=164
rm -rf /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules

# Remove any temporary work files, including the postinstall.sh script
rm -f /home/${account}/{*.iso,postinstall*.sh}

### Compress Image Size

# Zero out the free space to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

exit

# And we're done.
