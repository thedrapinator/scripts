#!/bin/bash

#Kali-install script

cd /opt
sudo apt update
sudo apt install -y bloodhound eyewitness chromium gedit enum4linux ldapscripts jq

#eyewitness install
sudo git clone https://github.com/FortyNorthSecurity/EyeWitness.git
sudo /opt/EyeWitness/Python/setup/setup.sh
#run with: /opt/EyeWitness/Python/EyeWitness.py -x nmap.xml --no-prompt --delay 10 -d eyewitness

#nmap-grep
sudo git clone https://github.com/sirchsec/nmap-grep.git

#xmltocsv
sudo git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git

echo "COPY OVER SSH CONFIG AND CHANGE PROXYCHAINS CONFIG"
echo "MANUAL INSTALL FOXYPROXY AND WAPALIZER"
echo "CHANGE TRANSPARENCY IN VM"
