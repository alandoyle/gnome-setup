#!/bin/bash
#
# Install GNOME Desktop Setup script
# 
# Copyright (C) 2023 Alan Doyle
#
# https://github.com/alandoyle/gnome-setup/
#
################################################################################
#
# Root check
#
clear
if [ `id -u` -eq 0 ] ; then
    echo "ERROR: This script should NOT be run as root or using sudo."
    echo "                          ---"
    exit 99
fi
#
################################################################################
#
# Cache sudo password to allow the rest of the script to proceed in an
# automated fashion.
#
sudo ls > /dev/null
#
################################################################################
#
# Quieten apt
#
cat << EOF > /tmp/unattended.conf
# Restart services (l)ist only, (i)nteractive or (a)utomatically. 
\$nrconf{restart} = 'l'; 
# Disable hints on pending kernel upgrades. 
\$nrconf{kernelhints} = 0; 
EOF
sudo mv /tmp/unattended.conf /etc/needrestart/conf.d/99-unattended.conf
export NEEDRESTART_SUSPEND=true
export DEBIAN_FRONTEND=noninteractive
sudo pro config set apt_news=false
#
################################################################################
#
# Prep system
#
sudo apt update
sudo apt -y upgrade
sudo apt -y install coreutils git curl apt-transport-https ca-certificates \
                    software-properties-common
#
################################################################################
#
# Clone git repository
#
cd /usr/share
sudo git clone https://github.com/alandoyle/gnome-setup gnome-setup
#
################################################################################
#
# Prep install
#
cd gnome-setup
[ -f ./setup.sh  ] && chmod a+x ./setup.sh bin/*
#
################################################################################
#
# Start installation
#
[ -f ./setup.sh  ] && ./setup.sh
#
################################################################################
