#!/bin/bash

#Usage whois.sh <domain-name>

touch whois.txt
while read ip; do echo $ip; whois $ip | grep -i $1; done < inscope.txt | tee whois.txt
