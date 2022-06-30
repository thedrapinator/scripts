#!/bin/bash

# Usage: combine-ntlm.sh ntds.dit cracked.txt

#Get Userlist of cracked hashes
while read -r line; do grep `echo $line | cut -d ":" -f1` $1; echo $line|cut -d ":" -f2; done < $2 | grep ::: | cut -d '\' -f2 | cut -d : -f1 > CRACKED-USERLIST.txt

#Password matching for pipal analysis
#while read -r line; do grep `echo $line | cut -d ":" -f4` $2; echo $line|cut -d ":" -f1,4 | cut -d " " -f5; done < $1
while read -r line; do grep `echo -n $line | cut -d ":" -f4` $2; echo -n $line|cut -d ":" -f1,4| cut -d " " -f5 ; done < $1 | grep -v '\\' | cut -d : -f2 > PIPAL.txt
