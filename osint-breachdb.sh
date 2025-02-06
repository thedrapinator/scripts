#!/bin/bash

# Add API.txt file instead of having to manually enter it every time
# change ability to enter folder name seperate from domain

echo "Enter company domain (ex. tesla.com)"
read -p 'Domain: ' domain
read -p 'api key: ' api
### SET VARIABLES ###
echo "Domain = $domain"
companyname=`echo $domain | cut -d "." -f1`
echo "Company Name = $companyname"
companypath=/home/kali/projects/$companyname/osint
scripts=/home/kali/scripts
echo "Files stored in $companypath"

#Make scripts executable
chmod +x $scripts/*

#make folder if it does not exist
mkdir -p $companypath
cd $companypath

###Block Comment for troubleshooting ####
: <<'END'
END
#########################################

## Breach Database Emails
curl -H "Authorization: apikey $api" https://search.breachinator.com/search\?domain\=$domain\&limit=50000 | jq -r '.[] | "\(.username) \(.password)"' > $companypath/breach.txt
cat $companypath/breach.txt | cut -d " " -f1 > $companypath/emails_tmp.txt

#BreachDB Users
#cat $companypath/breach.txt | cut -d "@" -f1 | grep -v "\." | sort -u > $companypath/possible_breach_tmp.txt
#cat $companypath/breach.txt | cut -d "@" -f1 | grep "\." | sed -r 's/(.)\S*\.(.*)/& \L\1\2/' | cut -d " " -f2 | sort -u >> $companypath/possible_breach_tmp.txt
#sort -u $companypath/possible_breach_tmp.txt > $companypath/possible_breach_users.txt
#rm $companypath/possible_breach_tmp.txt

#BreachDB Passwords Only
cat $companypath/breach.txt | cut -d " " -f2 > $companypath/breach-pass.txt
pipal $companypath/breach-pass.txt > breach-pass-pipal.txt

##Create Password Spray List
mkdir -p $companypath/spray
cd $companypath/spray
$scripts/credparse.sh $companypath/breach.txt

echo "=======DONE======"
