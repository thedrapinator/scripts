#!/bin/bash

# Usage: combine-ntlm.sh ntds.txt cracked.txt

#Parse and match with john
cat $1 | grep ::: > tmp.ntds.txt
cat $2 | cut -d : -f2 > tmp.pass.txt
john tmp.ntds.txt --wordlist=tmp.pass.txt --format=NT
john tmp.ntds.txt --format=NT --show > john.txt

#User list and Pass File
cat john.txt | grep ::: | cut -d : -f2 > CLEAR-PASS.txt

#From ldapdomaindump
cat domain_users.grep | grep 'Domain Admin' | grep -v Disabled | cut -d$'\t' -f3 > domain-admins.txt
grep -f domain-admins.txt john.txt | cut -d : -f1,2 > CLEAR-DOMAIN-ADMIN.txt

pipal CLEAR-PASS.txt > CLEAR-PIPAL.txt
