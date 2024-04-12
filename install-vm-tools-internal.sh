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
sudo apt install -y enum4linux ldapscripts jq parallel seclists nuclei #bloodhound

#netexec
sudo apt install pipx git
pipx ensurepath
pipx install git+https://github.com/Pennyw0rth/NetExec

#Python virtual env
cd ~
sudo apt install -y python3-venv #python3.10-venv
#python3 -m venv env
#source env/bin/activate

#Aquatone
cd $tools
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip

#Kerbrute
cd $tools
wget https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64
chmod +x kerbrute_linux_amd64

#Bloodhound python
git clone https://github.com/fox-it/BloodHound.py $tools/Bloodhound.py
cd $tools/Bloodhound.py
#python3 setup.py install

#SSH SCan
git clone https://github.com/evict/SSHScan $tools/SSHScan

#nmap-grep
git clone https://github.com/sirchsec/nmap-grep.git $tools/nmap-grep

#xmltocsv
git clone https://github.com/laconicwolf/Nmap-Scan-to-CSV.git $tools/Nmap-Scan-to-CSV

#Mitm6
git clone https://github.com/dirkjanm/mitm6 $tools/mitm6
cd $tools/mitm6
#python3 setup.py install

#noPac
git clone https://github.com/Ridter/noPac $tools/noPac

#PetitPotam
git clone https://github.com/topotam/PetitPotam $tools/PetitPotam
cd $tools/PetitPotam
#python3 setup.py install

#Certipy
git clone https://github.com/ly4k/Certipy $tools/Certipy
cd $tools/Certipy
#python3 setup.py install

#PKINIT
git clone https://github.com/dirkjanm/PKINITtools $tools/PKINITtools


#Deactiveate Python virtual env
#deactivate

echo "CHANGE PROXYCHAINS CONFIG"
echo "SET PROXYCHAINS TO SOCKS 5 8810"
echo "CHANGE TRANSPARENCY IN TERMINATOR AND ENABLE INFINITE SCROLL"
echo "CHANGE CME CONFIG FROM PWNED to ADMIN"
