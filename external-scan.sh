#!/bin/bash

echo "Enter company domain (ex. tesla.com)"
read -p 'Domain: ' $domain

### SET VARIABLES ###
echo "Domain = $domain"
companyname=`echo $domain | cut -d "." -f1`
echo "Company Name = $companyname"
companypath=~/projects/$companyname
echo "Files stored in $companypath"
cidr=`sed -z 's/\n/ -cidr /g' $companypath/inscope.txt | sed 's/.......$//g'`
#echo $cidr

#make folder if it does not exist
mkdir -p $companypath

echo "ENTER/VERIFY IN SCOPE IP ADDRESSES ONE ON EACH LINE IN CIDR NOTATION!!! Opening file in gedit please wait....."
sleep 5
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

### nmap scan ##                               ######### Replace with autorecon ##########
#mkdir -p $companypath/$companyname/nmap
#nmap -vv -sV -O -iL inscope.txt -oA $companypath/nmap/$companyname

## DNS zone transfer attempt??
#cat $companyname.gnmap| grep 53/open | cut -d " " -f2 > $companypath/nmap/dns_servers.txt
#nmap -p53 -sV -v --script=dns-zone-transfer.nse -iL $companypath/nmap/dns_servers.txt -oA $companypath/nmap/dns_zone_results

echo "STARTING AUTORECON!!!"
mkdir -p $companypath/autorecon
cd $companypath/autorecon
autorecon -t $companypath/inscope.txt --only-scans-dir -o $companypath/autorecon/results

# eyewitness (run at end because of prompt)
cd $companypath/
#### Fix to read autorecon results #####
#eyewitness -x $companypath/nmap/$companyname.xml --delay 5 -d $companypath/eyewitness     

