#!/bin/bash

#Sudo command to prompt for sudo privs
sudo echo 'SUDO PASSWORD CACHED'

#Chromium password
#chromium

### Disable sleep mode
sudo systemctl mask sleep.target suspend.target hibernate.target hybridsleep-target

#Set Variables
user=`whoami`
tools=/home/$user/tools
scripts=/home/$user/scripts

#Make executable
chmod +x $scripts/*

#make folder if it does not exist
mkdir -p $tools

#Install tools
sudo apt update
sudo apt reinstall libwacom-common -y
#sudo apt upgrade -y
sudo apt install -y bloodhound chromium gedit enum4linux ldapscripts jq parallel terminator seclists

#eyewitness install
#git clone https://github.com/FortyNorthSecurity/EyeWitness.git $tools/Eyewitness
#sudo $tools/EyeWitness/Python/setup/setup.sh
#run with: /opt/EyeWitness/Python/EyeWitness.py -x nmap.xml --no-prompt --delay 10 -d eyewitness

#Aquatone
cd $tools
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip

#Discover OSINT Tool
git clone https://github.com/leebaird/discover $tools/discover/
#All scripts must be ran from this location.
sudo chmod +x $tools/discover/update.sh
cd  $tools/discover
sudo ./update.sh

#SSH SCan
git clone https://github.com/evict/SSHScan $tools/SSHScan

#nmap-grep
git clone https://github.com/sirchsec/nmap-grep.git $tools/nmap-grep

#xmltocsv
git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git $tools/Nmap-Scan-to-CSV

echo "CHANGE DNS SERVERS IN /etc/resolv.conf"
echo "COPY OVER SSH CONFIG AND CHANGE PROXYCHAINS CONFIG"
echo "SET PROXYCHAINS TO SOCKS 5 8810 AND SSH DYNAMIC FORWARD"
echo "MANUAL INSTALL FOXYPROXY AND WAPALIZER"
echo "CHANGE TRANSPARENCY IN TERMINATOR"
