#!/bin/bash

tools=~/tools
scripts=~/scripts

companypath=~/projects
echo "Files stored in $companypath"

#make folder if it does not exist
mkdir -p $companypath

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

### metasploit nmap scan ##
mkdir -p $companypath/nmap
nmap -v -sSU -iL $companypath/inscope.txt -Pn -p U:53,111,161,500,623,2049,1000,T:21,22,23,25,53,80,81,110,111,123,137-139,161,389,443,445,500,512,513,548,623-624,1099,1241,1433-1434,1521,2049,2483-2484,3306,3389,4333,4786,4848,5432,5800,5900,5901,6000,6001,7001,8000,8080,8181,8443,16992-16993,27017,32764 -oA $companypath/nmap/initial

# nmap-grep
$tools/nmap-grep/nmap-grep.sh $companypath/nmap/initial.gnmap --out-dir $companypath/nmap/parsed --no-summary

### Add Metasploit Scripts ###
cd $companypath/nmap/parsed
msfconsole -r $scripts/metasploit.rc

###Resolve IP's###
cd $companypath/nmap/parsed
cat web-urls.txt| cut -d '/' -f3 | cut -d : -f1 | sort -u > web-ip.txt
$scripts/nslookuploop.sh web-ip.txt | tee log.nslookup

### big nmap scan ##
nmap -v -sV -Pn -iL $companypath/inscope.txt -oA $companypath/nmap/nmap

#Parse Rules
cd -p $companypath/nmap
#cat nmap.nmap | grep open | grep -v tcpwrapped | tr -s ' ' | cut -d ' ' -f4- |sort | uniq -c | sort -r > services.txt
cat nmap.nmap| grep open | tr -s ' '  | cut -d ' ' -f4- | sort | uniq -c | sort -r > $companypath/nmap/services.txt

##Convert nmap scan to CSV for spreadsheet
python3 $scripts/xml2csv.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv
#python3 /opt/Nmap-Scan-to-CSV/nmap_xml_parser.py -f $companypath/nmap/nmap.xml -csv $companypath/nmap/nmap.csv

# Aquatone
mkdir -p $companypath/aquatone
cd $companypath/aquatone
cat $companypath/nmap/nmap.xml | $tools/aquatone -nmap --ports xlarge -out $companypath/aquatone
#$tools/aquatone -nmap $companypath/nmap/nmap.xml -ports xlarge -out $companypath/aquatone 

#Make results folder
mkdir -p $companypath/nmap/results

#DNSrecon
echo "RUNNING DNS RECON"
mkdir -p $companypath/nmap/results/dnsrecon
cd $companypath/nmap/results/dnsrecon
parallel -a $companypath/nmap/parsed/dns-tcp-hosts.txt --progress -j 10 "dnsrecon -d {} -t axfr > {=s/\///g=}"

#SSLScan
echo "RUNNING SSL SCAN"
mkdir -p $companypath/nmap/results/sslscan
cd $companypath/nmap/results/sslscan
#while read -r line; do sslscan $line; done < $companypath/nmap/parsed/https-hosts.txt | tee $companypath/nmap/results/sslscan.txt
#while read -r line; do sslscan $line | tee $companypath/nmap/results/sslscan/`echo $line | sed 's/\///g'`; done < $companypath/nmap/parsed/https-hosts.txt
parallel -a $companypath/nmap/parsed/https-hosts.txt --progress -j 10 "sslscan {} > {=s/\///g=}"

#SSL Results
cd $companypath/nmap/results/sslscan
grep "vulnerable" * | grep -v "not" > vulnerable.txt #NEED TO CUT OUT IP IF RESULTS
grep "enabled" * | grep "TLSv1.0" | cut -d ":" -f1 > tls10.txt
grep "enabled" * | grep "TLSv1.1" | cut -d ":" -f1 > tls11.txt

#nuclei
echo "RUNNING NUCLEI"
mkdir -p $companypath/nmap/results/nuclei
cd $companypath/nmap/results/nuclei
parallel -a $companypath/nmap/parsed/web-urls.txt --progress -j 1 "nuclei -no-interactsh -u {} > {=s/\///g=}"

#nikto
##echo "RUNNING NIKTO"
##mkdir -p $companypath/nmap/results/nikto
##cd $companypath/nmap/results/nikto
#while read -r line; do nikto -h $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/nikto.txt
#while read -r line; do proxychains -q nikto -h $line -maxtime 1h | tee $companypath/nmap/results/nikto/`echo $line | sed 's/\///g'`; done < $companypath/nmap/parsed/web-urls.txt
#parallel -a $companypath/nmap/parsed/web-urls.txt --progress -j 10 proxychains -q nikto -h {} -maxtime 1h -output . -Format txt
##parallel -a $companypath/nmap/parsed/web-urls.txt --progress -j 10 "proxychains -q nikto -h {} -maxtime 1h > {=s/\///g=}"

#Nikto Grep Vulns
#cd $companypath/nmap/results/nikto
#grep -i 'real ip' http* > ip-in-header.txt  #Internal IP in Header
#grep -i 'ip address found' http* >> ip-in-header.txt
#grep -i 'outdated' http* > outdated-software.txt
#grep -i 'interesting' http* > interesting.txt
#grep -i 'indexing' http* >> interesting.txt
#grep -i 'OSVBD' http* > osvdb.log
#grep -i 'RFC' http* > rfc.log
#grep -i 'vulnerable' http* > vulnerable.log

#ffuf
##mkdir -p $companypath/nmap/results/ffuf
##cd $companypath/nmap/results/ffuf
#while read -r line; do dirb $line; done < $companypath/nmap/parsed/web-urls.txt | tee $companypath/nmap/results/dirb.txt
#ffuf -w /usr/share/wordlists/dirb/common.txt -u $line/FUZZ -o ffuf-
#ffuf -w web-urls.txt:TARGET -w /usr/share/wordlists/dirb/common.txt -u TARGET/FUZZ
#interlace -tL <domain list> -c "ffuf -u _target_ -w /usr/share/wordlists/dirb/common.txt -se -sf -mc all -fc 300,301,302,303,500,400,404 | tee ffuf/$url.txt
#interlace -tL $companypath/nmap/parsed/web-urls.txt -c "ffuf -u _target_ -w /usr/share/wordlists/dirb/common.txt -se -sf -mc all -fc 300,301,302,303,500,400,404 | tee ffuf/$url.txt
#while read -r line; do proxychains -q ffuf -w /usr/share/wordlists/dirb/common.txt -u $line''FUZZ -maxtime-job 3600 -se -sf -mc all -fc 300,301,302,303,500,400,404 | tee $companypath/nmap/results/ffuf/`echo $line | sed 's/\///g'`; done < $companypath/nmap/parsed/web-urls.txt
##parallel -a $companypath/nmap/parsed/web-urls.txt --progress -j 10 "proxychains -q ffuf -w /usr/share/wordlists/dirb/common.txt -u {}FUZZ -maxtime-job 3600 -noninteractive -se -sf -mc all -fc 300,301,302,303,500,400,404 > {=s/\///g=}"

echo "SCRIPT COMPLETED!!!"
