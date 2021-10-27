#/bin/bash

###### TO DO  #######
# Sort files to folders you crazy unorganized person
# add breachcount script after breachparse
# make sure breachparse and pwned are installed in the tools script

echo "Enter company domain (ex. tesla.com)"
read -p 'Domain: ' domain

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

####(NOT NEEDED FOR OSINT)#####
# if inscope does not exist then exit   

#if [ ! -f $companypath/inscope.txt ]
#then
#    echo "inscope.txt not found. Exiting!"
#    exit 1
#else
#    echo "In scope file found."
#fi



###Block Comment for troubleshooting ####
: <<'END'
END
#########################################


### GOOGLE DORKING #####
echo "LAUNCHING BROWSER!"
firefox "https://www.google.com/search?q=site:$domain ext:pwd OR ext:bak OR ext:skr OR ext:pgp OR ext:config OR ext:psw OR ext:inc OR ext:mdb OR ext:conf OR ext:dat OR ext:eml OR ext:log"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain inurl:'htaccess' OR inurl:'passwd' OR inurl:'shadow' OR inurl:'htusers' OR inurl:'web.config' OR inurl:'ftp' OR inurl:'confidential' OR inurl:'login' OR inurl:'admin'"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain intitle:'Index of' OR intitle:'index.of'"&
sleep 1
firefox "https://www.google.com/search?q=site:$domain (ext:doc OR ext:docx OR ext:pdf OR ext:xls OR ext:xlsx OR ext:txt OR ext:ps OR ext:rtf OR ext:odt OR ext:sxw OR ext:psw OR ext:ppt OR ext:pps OR ext:xml) 'username * password'"&
sleep 1
#### DNSDUMPSTER ###
firefox "https://dnsdumpster.com/"&
sleep 1
### WAYBACK ###
firefox "https://web.archive.org/web/*/$domain/*"&
echo "Search wayback search for pwd bak skr pgp config psw inc mdb conf dat eml log"
sleep 1
### ROBOTS ###
firefox "$domain/robots.txt"
sleep 1




########## SCANS  ##########

### AMASS SCANS ###
echo "LAUNCHING AMASS!"

#amass enum -d $domain -config ~/config.ini -cidr $cidr
amass enum -d $domain -config ~/config.ini


amass db -d $domain -names -ip > $companypath/amass_domains_ip.txt
cat $companypath/amass_domains_ip.txt > $companypath/domain_ip_combined.txt

### THEHARVESTER ###
echo "LAUNCHING HARVESTER!"
theHarvester -d $domain -b all > $companypath/harvester_all.txt
# add to domain ip
cat $companypath/harvester_all.txt | grep $domain | grep -v @ | grep -v Target | sed 's/:/ /g' >> $companypath/domain_ip_combined.txt
# Create email list
cat $companypath/harvester_all.txt | grep @$domain > $companypath/email_combined.txt


### BREACHES ###
echo "LAUNCHING BREACHPARSE!"
cd $companypath
breach-parse @$domain $companyname-breach
cat $companypath/$companyname-breach-users.txt >> $companypath/email_combined.txt


###### SORT DATA #####

cat $companypath/email_combined.txt| sort -u > $companypath/email_FINAL.txt
cat $companypath/domain_ip_combined.txt| sort -u > $companypath/domain_ip_FINAL.txt

### Turn emails into f-last format ###
cat $companypath/email_FINAL.txt | cut -d "@" -f1 | grep "\." | sed -r 's/(.)\S*\.(.*)/& \L\1\2/' | cut -d " " -f2 | sort -u > $companypath/possible_domain_users.txt


###### CLEANUP ######

#Move all working files to another folder


#########################
echo "SCRIPT COMPLETED!"
echo "Data is located in $companypath!"

