#!/bin/bash


#Set Variables
user=`whoami`
tools=~/tools
scripts=~/scripts

#Make executable
chmod +x $scripts/*

#make folder if it does not exist
mkdir -p $tools

#Install tools
sudo apt update
sudo apt install -y enum4linux ldapscripts jq parallel seclists bloodhound

#Aquatone
cd $tools
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip

#Bloodhound python
git clone https://github.com/fox-it/BloodHound.py $tools/Bloodhound.py
cd $tools/Bloodhound.py
python3 setup.py install

#SSH SCan
git clone https://github.com/evict/SSHScan $tools/SSHScan

#nmap-grep
git clone https://github.com/sirchsec/nmap-grep.git $tools/nmap-grep

#xmltocsv
git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git $tools/Nmap-Scan-to-CSV

echo "CHANGE PROXYCHAINS CONFIG"
echo "SET PROXYCHAINS TO SOCKS 5 8810"
