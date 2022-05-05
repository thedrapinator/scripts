#!/bin/bash

echo "Enter company domain (ex. tesla.com)"
read -p 'Domain: ' domain

### SET VARIABLES ###
echo "Domain = $domain"
companyname=`echo $domain | cut -d "." -f1`
echo "Company Name = $companyname"
companypath=/home/kali/projects/$companyname
echo "Files stored in $companypath"

#make folder if it does not exist
mkdir -p $companypath

echo "ENTER/VERIFY IN SCOPE IP ADDRESSES ONE ON EACH LINE IN CIDR NOTATION!!! Opening file in gedit please wait....."
sleep 1
gedit $companypath/inscope.txt

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
sudo nmap -vv -Pn -sV -O -iL $companypath/inscope.txt -oA $companypath/nmap/nmap

##Convert nmap scan to CSV for spreadsheet
python3 /opt/scripts/xml2csv.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv
#python3 /opt/Nmap-Scan-to-CSV/nmap_xml_parser.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv

# eyewitness
mkdir -p $companypath/eyewitness
cd $companypath/eyewitness
#sudo eyewitness -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness
/opt/EyeWitness/Python/EyeWitness.py -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness

# nmap-grep
/opt/nmap-grep/nmap-grep.sh $companypath/nmap/nmap.gnmap --out-dir $companypath/nmap/parsed

#nikto
mkdir -p $companypath/nmap/results
#while read -r line; do nikto -h $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/nikto.txt

#dirb
#while read -r line; do dirb $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/dirb.txt

echo "SCRIPT COMPLETED!!!"
