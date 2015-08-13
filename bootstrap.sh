#!/bin/bash

# Prevent dialogs to enter settings
# See http://mkrmr.wordpress.com/2012/08/12/add-your-own-customization-to-vagrant-boxes/
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

# NOTE: If kernel is upgraded, you probably need to upgrade VirtualBox Guest Additions as well
#sudo apt-get -y dist-upgrade

# Required for non-interactive dpkg-reconfigure
sudo apt-get install -y debconf-utils

# Make sure that user "vagrant" exists, while "ubuntu" does not
id vagrant &>/dev/null || sudo adduser vagrant
id ubuntu  &>/dev/null && sudo deluser ubuntu

# Example: Install Apache
#apt-get install -y apache2
#rm -rf /var/www
#ln -fs /vagrant /var/www

# Upgrading from Ubuntu server to desktop
# See http://askubuntu.com/questions/322122/switching-from-server-to-desktop
#sudo apt-get -y install ubuntu-desktop

# Install XFCE
# See http://www.enqlu.com/2014/03/how-to-install-xfce-desktop-on-ubuntu-14-04-lts-trusty-tahr.html
#sudo apt-get install xfce4

# Install git and related tools
sudo apt-get -y install git git-svn tig

# Install package to enable autocompletion (i.e. for git)
sudo apt-get -y install bash-completion

# Install other things I will never live without...
sudo apt-get -y install mc

# Install useful packages for troubleshooting remote X (xlogo)
#sudo apt-get -y install x11-apps xauth

# Install packages required for building the Linux kernel
sudo apt-get -y install bc lzop make ncurses-dev u-boot-tools

# Install packages required by Sourcery CodeBench 2014.05 installer
#sudo dpkg --add-architecture i386
#sudo apt-get update
#sudo apt-get -y install libgtk2.0-0:i386 libxtst6:i386 \
#    gtk2-engines-murrine:i386 lib32stdc++6 libxt6:i386 \
#    libdbus-glib-1-2:i386 libasound2:i386

# Install packages required by MEL 2014.05 (Yocto)
sudo apt-get -y install gawk g++ diffstat texinfo chrpath

# Install packages required by Vista 3.9.0
#sudo apt-get -y install xterm

# Configure /bin/bash as default shell (required by Yocto, MEL, etc.)
echo "dash dash/sh boolean false" | sudo debconf-set-selections
sudo dpkg-reconfigure -f noninteractive dash
#ls -la /bin/sh

# === EOF ===
