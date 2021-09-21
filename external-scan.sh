#!/bin/bash

#Inscope and arguments from first script






### nmap scan
mkdir -p $companypath/$companyname/nmap
nmap -v -sV -O -iL inscope.txt -oA $companypath/$companyname/nmap/$companyname



## DNS zone transfer attempt??
cat energysolutions.gnmap| grep 53/open | cut -d " " -f2 > dns_servers.txt
nmap -p53 -sV -v --script=dns-zone-transfer.nse -iL dns_servers.txt -oA dns_zone_results


# eyewitness (run at end because of prompt)
cd $companypath/$companyname/nmap/
eyewitness -x $companypath/$companyname/nmap/$companyname.xml --delay 5


