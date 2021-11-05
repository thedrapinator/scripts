#!/bin/bash

echo "Enter company folder name"
read -p 'Domain: ' companyname

### SET VARIABLES ###
echo "Company Name = $companyname"
companypath=~/projects/$companyname
mkdir -p $companypath
echo "Files stored in $companypath"
cidr=`sed -z 's/\n/ -cidr /g' $companypath/inscope.txt | sed 's/.......$//g'`
#echo $cidr

#make folder if it does not exist
mkdir -p $companypath

echo "ENTER/VERIFY IN SCOPE IP ADDRESSES ONE ON EACH LINE IN CIDR NOTATION!!! Opening file in gedit please wait....."
sleep 3
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
nmap -vv -sV -O -iL $companypath/inscope.txt -oA $companypath/nmap/$companyname

##Convert nmap scan to CSV for spreadsheet
python3 ~/scripts/xml2csv.py -f $companypath/nmap/$companyname.xml -csv $companypath/nmap/$companyname.csv

# eyewitness
cd $companypath/
eyewitness -x $companypath/nmap/$companyname.xml --no-prompt --delay 5 -d $companypath/eyewitness      

## DNS zone transfer attempt ## AUTORECON DOES THIS
#cat $companyname.gnmap| grep 53/open | cut -d " " -f2 > $companypath/nmap/dns_servers.txt
#nmap -p53 -sV -v --script=dns-zone-transfer.nse -iL $companypath/nmap/dns_servers.txt -oA $companypath/nmap/dns_zone_results

### AUTORECON ###
echo "STARTING AUTORECON!!!"
mkdir -p $companypath/autorecon
#cd $companypath/autorecon
autorecon -t $companypath/inscope.txt -o $companypath/autorecon

## Sort Results ###

#Sort zone transfers
cd $companypath/autorecon
touch zone_transfer_temp.txt
find -name *zone-transfer* -exec cat {} \; | grep ^'\.' | cut -f7 >> zone_transfer_temp.txt 
cat zone_transfer_temp.txt | sort -u > zone_transfer.txt
rm zone_transfer_temp.txt

echo "SCRIPT COMPLETED!!!"
