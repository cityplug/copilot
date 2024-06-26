#!/bin/bash

# Debian - (copilot.ux-estate.local) setup script - pve copilot

sudo apt update && sudo apt full-upgrade -y && sudo reboot
sudo sed -i -e 's/bullseye/bookworm/g' /etc/apt/sources.list
sudo sed -i 's/non-free/non-free non-free-firmware/g' /etc/apt/sources.li                                                                                                             st
sudo sed -i -e 's/bullseye/bookworm/g' /etc/apt/sources.list.d/raspi.list
sudo apt update && sudo apt full-upgrade -y && sudo apt clean -y && sudo apt autoremove -y


#> mkdir -p /home/focal/.ssh/ && touch /home/focal/.ssh/authorized_keys && curl -sSf https://github.com/cityplug.keys >> /home/focal/.ssh/authorized_keys
#> sudo sed -i '15i\Port 4792\n' /etc/ssh/sshd_config
#> sudo apt update && sudo apt install git ufw -y && sudo su
#> cd /opt/copilot && git clone https://github.com/cityplug/copilot && chmod +x /opt/copilot/* &&  ./run.sh

# --- Security Addons 
groupadd ssh-users
usermod -aG ssh-users focal
sed -i '15i\AllowGroups ssh-users\n' /etc/ssh/sshd_config
ufw deny 22
ufw allow 4792
ufw logging on
ufw enable
ufw status

# --- Addons
rm -rf /etc/update-motd.d/* && rm -rf /etc/motd && 
wget https://raw.githubusercontent.com/cityplug/copilot/main/10-uname -O /etc/update-motd.d/10-uname && chmod +x /etc/update-motd.d/10-uname
mkdir -p /opt/appdata

# --- Disable Bluetooth & Splash
echo "
disable_splash=1
dtoverlay=disable-bt" >> /boot/config.txt

echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf

# --- Provision swap
fallocate -l 4G /swapfile
chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile
# --- Add swap to the /fstab file & Verify command
sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab' && cat /etc/fstab
sh -c 'echo "apt autoremove -y" >> /etc/cron.monthly/autoremove'
chmod +x /etc/cron.monthly/autoremove

# --- Install Docker Engine
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt install docker-compose -y
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && usermod -aG docker focal

# --- Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --advertise-routes=10.1.1.0/24

#--
systemctl enable docker 
docker-compose --version && docker --version
docker network create frontend
docker network create backend
docker compose up -d
docker ps

apt update -y && apt install -y && apt full-upgrade -y
sleep 10
#--------------------------------------------------------------------------------
reboot