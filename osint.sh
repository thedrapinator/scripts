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

### GOOGLE DORKING #####
echo "LAUNCHING BROWSER!"
firefox "https://www.google.com/search?q=site:$domain ext:pwd OR ext:bak OR ext:skr OR ext:pgp OR ext:config OR ext:psw OR ext:inc OR ext:mdb OR ext:conf OR ext:dat OR ext:eml OR ext:log"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain inurl:'htaccess' OR inurl:'passwd' OR inurl:'shadow' OR inurl:'htusers' OR inurl:'web.config' OR inurl:'ftp' OR inurl:'confidential' OR inurl:'login' OR inurl:'admin'"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain intitle:'Index of' OR intitle:'index.of'"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain (ext:doc OR ext:docx OR ext:pdf OR ext:xls OR ext:xlsx OR ext:txt OR ext:ps OR ext:rtf OR ext:odt OR ext:sxw OR ext:psw OR ext:ppt OR ext:pps OR ext:xml) 'username password'"&
sleep 1
### ROBOTS ###
firefox "$domain/robots.txt"&
sleep 1
### WAYBACK ###
firefox "https://web.archive.org/web/*/$domain/*"&
echo "Search wayback search for pwd bak skr pgp config psw inc mdb conf dat eml log"
#github.com/tomnomnom/waybackurls waybackurls <target> | grep "\.js" 
sleep 1


### MANUAL SEARCHES ###
echo "Domain is: $domain"
#### DNSDUMPSTER ###
#firefox "https://dnsdumpster.com/"&
## Phonebook.cz combine with emails
firefox "https://phonebook.cz/"&
## Hunter.io
#firefox "https://hunter.io/"&

#Combine email lists, clean, make possible users list
echo "==== LAUNCHING GEDIT PLEASE ADD EMAILS FROM PHONEBOOK.CZ TO FILE ===="
gedit $companypath/emails_tmp.txt
cat $companypath/emails_tmp.txt | sort -u > $companypath/emails_combined.txt
cat $companypath/emails_combined.txt | cut -d "@" -f1 | grep -v "\." | sort -u > $companypath/possible_users_tmp.txt
cat $companypath/emails_combined.txt | cut -d "@" -f1 | grep "\." | sed -r 's/(.)\S*\.(.*)/& \L\1\2/' | cut -d " " -f2 | sort -u >> $companypath/possible_users_tmp.txt
sort -u $companypath/possible_users_tmp.txt > $companypath/possible_users.txt
rm $companypath/emails_tmp.txt
rm $companypath/possible_users_tmp.txt

echo "==== Gathering Files for Metadata Analysis ===="
cd $companypath
metagoofil -d $domain -t docx,pdf,xlsx,pptx -o meta -w
#metagoofil -d $domain -t doc,docx,pdf,csv,xls,xlsx,ppt,pptx -o files -w
cd $companypath/meta
for f in ./*; do exiftool "$f" > $f.meta; done
grep -E -i "name|version|author|creator|tool|producer" *.meta | grep -i -v -E "file name|swatch|exiftool|plate|font" > ALL.meta

echo "=======DONE======"
