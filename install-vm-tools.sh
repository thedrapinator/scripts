#!/bin/bash

#Kali-install script

cd /opt
sudo apt update
sudo apt install -y bloodhound eyewitness chromium gedit enum4linux ldapscripts jq

#eyewitness install
cd /opt
sudo git clone https://github.com/FortyNorthSecurity/EyeWitness.git
sudo /opt/EyeWitness/Python/setup/setup.sh
#run
#/opt/EyeWitness/Python/EyeWitness.py -x nmap.xml --no-prompt --delay 10 -d eyewitness

#xmltocsv
sudo git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git

echo "COPY OVER SSH CONFIG AND PROXYCHAINS CONFIG"
echo "CHANGE TRANSPARENCY IN VM"
