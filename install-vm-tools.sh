#!/bin/bash

#Kali-install script

install=~/tools

#make folder if it does not exist
mkdir -p $install

#sudo apt update
#sudo apt reinstall libwacom-common -y
#sudo apt upgrade -y
sudo apt install -y bloodhound eyewitness chromium gedit enum4linux ldapscripts jq

#eyewitness install
git clone https://github.com/FortyNorthSecurity/EyeWitness.git $install/Eyewitness
$install/EyeWitness/Python/setup/setup.sh
#run with: /opt/EyeWitness/Python/EyeWitness.py -x nmap.xml --no-prompt --delay 10 -d eyewitness

#Interlace install for multi threading commands
git clone https://github.com/codingo/Interlace  $install/Interlace
sudo python3  $install/Interlace/setup.py install

#Discover OSINT Tool
git clone https://github.com/leebaird/discover $install/discover/
#All scripts must be ran from this location.
sudo chmod +x  $install/discover/update.sh
cd  $install/discover
sudo ./update.sh

#nmap-grep
git clone https://github.com/sirchsec/nmap-grep.git $install/nmap-grep

#xmltocsv
git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git  $install/Nmap-Scan-to-CSV

echo "COPY OVER SSH CONFIG AND CHANGE PROXYCHAINS CONFIG"
echo "MANUAL INSTALL FOXYPROXY AND WAPALIZER"
echo "CHANGE TRANSPARENCY IN VM"
