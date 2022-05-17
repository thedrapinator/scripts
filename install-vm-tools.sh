#!/bin/bash

#Sudo command to prompt for sudo privs
sudo echo 'SUDO PASSWORD CACHED'

user='whoami'
tools=/home/$user/tools
scripts=/home/$user/scripts

chmod +x $scripts/*

#make folder if it does not exist
mkdir -p $tools

sudo apt update
sudo apt reinstall libwacom-common -y
#sudo apt upgrade -y
sudo apt install -y bloodhound chromium gedit enum4linux ldapscripts jq

#eyewitness install
git clone https://github.com/FortyNorthSecurity/EyeWitness.git $tools/Eyewitness
sudo $tools/EyeWitness/Python/setup/setup.sh
#run with: /opt/EyeWitness/Python/EyeWitness.py -x nmap.xml --no-prompt --delay 10 -d eyewitness

#Interlace install for multi threading commands
#git clone https://github.com/codingo/Interlace  $toolsInterlace
#sudo python3 $install/Interlace/setup.py install

#Discover OSINT Tool
git clone https://github.com/leebaird/discover $tools/discover/
#All scripts must be ran from this location.
sudo chmod +x  $tools/discover/update.sh
cd  $tools/discover
sudo ./update.sh

#nmap-grep
git clone https://github.com/sirchsec/nmap-grep.git $tools/nmap-grep

#xmltocsv
git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git  $tools/Nmap-Scan-to-CSV

echo "COPY OVER SSH CONFIG AND CHANGE PROXYCHAINS CONFIG"
echo "MANUAL INSTALL FOXYPROXY AND WAPALIZER"
echo "CHANGE TRANSPARENCY IN TERMINAL"
