#!/bin/bash

# Usage: combine-ntlm.sh ntds.dit cracked.txt

#cat $1 | grep ::: | grep -v '\$' > tmp.ntds.users.txt

#Get Userlist of cracked hashes
#while read -r line; do grep `echo $line | cut -d ":" -f1` tmp.ntds.users.txt; echo $line|cut -d ":" -f2; done < $2 | grep ::: | cut -d '\' -f2 | cut -d : -f1 > zCRACKED-USERLIST.txt

#Password matching for pipal analysis
#while read -r line; do grep `echo $line | cut -d ":" -f4` $2; echo $line|cut -d ":" -f1,4 | cut -d " " -f5; done < tmp.ntds.users.txt
#while read -r line; do grep `echo -n $line | cut -d ":" -f4` $2; echo -n $line|cut -d ":" -f1,4| cut -d " " -f5 ; done < tmp.ntds.users.txt | grep -v '\\' | cut -d : -f2 > zPIPAL.txt

#rm tmp.ntds.users.txt

cat $2 | cut -d : -f2 > tmp.pass.txt
cat $1 | grep ::: | cut -d ' ' -f26  > tmp.ntds.txt  #Do a rev and make more accurate
john tmp.ntds.txt --wordlist=tmp.pass.txt --format=NT
john tmp.ntds.txt --format=NT --show | cut -d : -f1,2 > COMBINED.txt

cat COMBINED.txt | cut -d : -f1 > COMBINED-USERS.txt
cat COMBINED.txt | cut -d : -f2 > COMBINED-PASS.txt

grep -f admins.txt COMBINED.txt > COMBINED-ADMINS.txt

pipal COMBINED-PASS.txt
