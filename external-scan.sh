#!/bin/bash

#Inscope and arguments from first script


### IF ARG is anything but 1 then write out help file ###



### SET VARIABLES ###
domain=$1
echo "Domain = $domain"
companyname=`echo $domain | cut -d "." -f1`
echo "Company Name = $companyname"
companypath=~/projects/$companyname
echo "Files stored in $companypath"
cidr=`sed -z 's/\n/ -cidr /g' $companypath/inscope.txt | sed 's/.......$//g'`
#echo $cidr

#make folder
mkdir -p ~/projects/$companyname

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




### nmap scan
mkdir -p $companypath/$companyname/nmap
nmap -v -sV -O -iL inscope.txt -oA $companypath/$companyname/nmap/$companyname



## DNS zone transfer attempt??
cat energysolutions.gnmap| grep 53/open | cut -d " " -f2 > dns_servers.txt
nmap -p53 -sV -v --script=dns-zone-transfer.nse -iL dns_servers.txt -oA dns_zone_results


# eyewitness (run at end because of prompt)
cd $companypath/$companyname/nmap/
eyewitness -x $companypath/$companyname/nmap/$companyname.xml --delay 5


