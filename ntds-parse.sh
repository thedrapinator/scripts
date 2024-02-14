#!/bin/bash

#impacket-secretsdump domain/user:'pass'@ip -user-status -outputfile log.NTDS.secretsdump
cat $1 | grep Enabled | grep -v '\$' | grep ':::' | cut -d ' ' -f1 > ntds.all
echo "`cat ntds.all | wc -l` enabled user hashes gathered"

#NT Hashes for hashtopolis
cat ntds.all | cut -d : -f4 > ntds.nt.hashtopolis
echo "`cat ntds.nt.hashtopolis | sort -u | wc -l` unique user password hashes"

#LM Hashes enabled
cat $1 | grep -av 'aad3b435b51404eeaad3b435b51404ee' | cut -d : -f1 > ntds.lm.hash.enabled
echo "`cat ntds.lm.hash.enabled | wc -l` accounts with LM hashes enabled"

#Blank Password
cat ntds.all | grep -a '31d6cfe0d16ae931b73c59d7e0c089c0' | cut -d : -f1 > ntds.no.pass
echo "`cat ntds.no.pass | wc -l` accounts with blank passwords"

cat ntds.all | grep -a '8846f7eaee8fb117ad06bdd830b7586c' | cut -d : -f1 > ntds.password.as.password
echo "`cat ntds.password.as.password | wc -l` accounts with password as password"
