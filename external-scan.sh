#!/bin/bash

user='whoami'
tools=/home/$user/tools
scripts=/home/$user/scripts

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
proxychains -q nmap -v -Pn -sV -O -iL $companypath/inscope.txt -oA $companypath/nmap/nmap
#sudo chown $user:$user $companypath/nmap/*

##Convert nmap scan to CSV for spreadsheet
python3 $scripts/xml2csv.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv
#python3 /opt/Nmap-Scan-to-CSV/nmap_xml_parser.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv

# eyewitness
mkdir -p $companypath/eyewitness
cd $companypath/eyewitness
#sudo eyewitness -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness
proxychains -q $tools/EyeWitness/Python/EyeWitness.py -x $companypath/nmap/nmap.xml --no-prompt --delay 10 -d $companypath/eyewitness

# nmap-grep
$tools/nmap-grep/nmap-grep.sh $companypath/nmap/nmap.gnmap --out-dir $companypath/nmap/parsed

#Make results folder
mkdir -p $companypath/nmap/results

#GET INTERLACE WORKING

#SSLScan
mkdir -p $companypath/nmap/results/sslscan
#while read -r line; do sslscan $line; done < $companypath/nmap/parsed/https-hosts.txt | tee $companypath/nmap/results/sslscan.txt
while read -r line; do proxychains -q sslscan $line | tee $companypath/nmap/results/sslscan/`echo $line | sed 's/\///g'`; done < $companypath/nmap/parsed/web-urls.txt

#nikto
mkdir -p $companypath/nmap/results/nikto
#while read -r line; do nikto -h $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/nikto.txt
while read -r line; do proxychains -q nikto -h $line -maxtime 1h | tee $companypath/nmap/results/nikto/`echo $line | sed 's/\///g'`; done < $companypath/nmap/parsed/web-urls.txt

#dirb
mkdir -p $companypath/nmap/results/ffuf
#while read -r line; do dirb $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/dirb.txt
#ffuf -w /usr/share/wordlists/dirb/common.txt -u $line/FUZZ -o ffuf-
#ffuf -w web-urls.txt:TARGET -w /usr/share/wordlists/dirb/common.txt -u TARGET/FUZZ
#interlace -tL <domain list> -c "ffuf -u _target_ -w /usr/share/wordlists/dirb/common.txt -se -sf -mc all -fc 300,301,302,303,500,400,404 | tee ffuf/$url.txt
#interlace -tL $companypath/nmap/parsed/web-urls.txt -c "ffuf -u _target_ -w /usr/share/wordlists/dirb/common.txt -se -sf -mc all -fc 300,301,302,303,500,400,404 | tee ffuf/$url.txt
while read -r line; do proxychains -q ffuf -w /usr/share/wordlists/dirb/common.txt -u $line''FUZZ -maxtime-job 3600 -se -sf -mc all -fc 300,301,302,303,500,400,404 | tee $companypath/nmap/results/ffuf/`echo $line | sed 's/\///g'`; done < $companypath/nmap/parsed/web-urls.txt

echo "SCRIPT COMPLETED!!!"
