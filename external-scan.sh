#!/bin/bash

tools=~/tools

echo "Enter project name"
read -p 'Project Name: ' companyname

### SET VARIABLES ###
echo "Company Name = $companyname"
companypath=~/projects/$companyname
echo "Files stored in $companypath"

#make folder if it does not exist
mkdir -p $companypath

echo "ENTER/VERIFY IN SCOPE IP ADDRESSES ONE ON EACH LINE IN CIDR NOTATION!!! Opening file in gedit please wait....."
sleep 1
nano $companypath/inscope.txt

# if inscope does not exist then exit
if [ ! -f $companypath/inscope.txt ]
then
    echo "inscope.txt not found. Exiting!"
    exit 1
else
    echo "In scope file found."
fi

###Block Comment for troubleshooting ####
: <<'END'
END
#########################################

### nmap scan ##
mkdir -p $companypath/nmap
sudo nmap -v -Pn -sV -O -iL $companypath/inscope.txt -oA $companypath/nmap/nmap

##Convert nmap scan to CSV for spreadsheet
python3 ~/scripts/xml2csv.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv
#python3 /opt/Nmap-Scan-to-CSV/nmap_xml_parser.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv

# eyewitness
mkdir -p $companypath/eyewitness
cd $companypath/eyewitness
#sudo eyewitness -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness
$tools/EyeWitness/Python/EyeWitness.py -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness

# nmap-grep
$tools/nmap-grep/nmap-grep.sh $companypath/nmap/nmap.gnmap --out-dir $companypath/nmap/parsed

#Make results folder
mkdir -p $companypath/nmap/results

#SSLScan
#while read -r line; do sslscan $line; done < $companypath/nmap/parsed/https-hosts.txt | tee $companypath/nmap/results/sslscan.txt

#nikto
#while read -r line; do nikto -h $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/nikto.txt

#dirb
#while read -r line; do dirb $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/dirb.txt

echo "SCRIPT COMPLETED!!!"
