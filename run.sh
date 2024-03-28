#!/bin/bash

# Debian *GB - (copilot.cityplug.io) setup script - pve copilot

# apt update -y && apt install git curl gnupg cifs-utils -y && apt full-upgrade -y && cd /opt && git c  lone https://github.com/cityplug/copilot && reboot
# chmod +x /opt/copilot/* && cd /opt/copilot && ./run.sh

# --- Addons
rm -rf /etc/update-motd.d/* && rm -rf /etc/motd && 
wget https://raw.githubusercontent.com/cityplug/copilot/main/10-uname -O /etc/update-motd.d/10-uname && chmod +x /etc/update-motd.d/10-uname

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf

sleep 20

#--------------------------------------------------------------------------------
reboot