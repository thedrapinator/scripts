#!/bin/bash

#impacket-secretsdump corp.yamww.com/rapid7:'Rapid7!Rapid7!'@10.8.22.39 -user-status -outputfile log.NTDS.secretsdump
cat $1 | grep Enabled | grep -v '\$' | grep ::: | rev | cut -d ' ' -f2,3,4,5,6,7,8,9 | rev > ntds.all
echo "`cat ntds.all | wc -l` user hashes gathered"

#NT Hashes for hashtopolis
cat ntds.all | cut -d : -f4 | sort -u > ntds.nt.hashtopolis
echo "`cat ntds.nt.hashtopolis | wc -l` unique user password hashes"

#LM Hashes enabled
cat ntds.all | grep -av 'aad3b435b51404eeaad3b435b51404ee' > ntds.lm.hash.enabled
echo "`cat ntds.lm.hash.enabled | wc -l` accounts with LM hashes enabled"

#Blank Password
cat ntds.all | grep -a '31d6cfe0d16ae931b73c59d7e0c089c0' > ntds.no.pass
echo "`cat ntds.no.pass | wc -l` accounts with blank passwords"

cat ntds.all | grep -a '8846f7eaee8fb117ad06bdd830b7586c' > ntds.password.as.password
echo "`cat ntds.password.as.password | wc -l` accounts with password as password"

