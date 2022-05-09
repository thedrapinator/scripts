#!/bin/bash

#Kali-install script

cd /opt
sudo apt update
sudo apt reinstall libwacom-common -y
sudo apt upgrade -y
sudo apt install -y bloodhound eyewitness chromium gedit enum4linux ldapscripts jq

#eyewitness install
sudo git clone https://github.com/FortyNorthSecurity/EyeWitness.git
sudo /opt/EyeWitness/Python/setup/setup.sh
#run with: /opt/EyeWitness/Python/EyeWitness.py -x nmap.xml --no-prompt --delay 10 -d eyewitness

#Interlace install for multi threading commands
sudo git clone https://github.com/codingo/Interlace /opt/Interlace
sudo python3 /opt/Interlace/setup.py install

#Discover OSINT Tool
sudo git clone https://github.com/leebaird/discover /opt/discover/
#All scripts must be ran from this location.
sudo chmod +x /opt/discover/update.sh
cd /opt/discover
sudo ./update.sh

#nmap-grep
cd /opt
sudo git clone https://github.com/sirchsec/nmap-grep.git

#xmltocsv
cd /opt
sudo git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git

echo "COPY OVER SSH CONFIG AND CHANGE PROXYCHAINS CONFIG"
echo "MANUAL INSTALL FOXYPROXY AND WAPALIZER"
echo "CHANGE TRANSPARENCY IN VM"
