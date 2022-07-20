#!/bin/bash

# Argument 1 is ntds file

#Grep users only
cat $1 | grep ::: | grep -v '\$' > log.ntds.users

#LM Hashes enabled
cat log.ntds.users | grep -av 'aad3b435b51404eeaad3b435b51404ee' > log.lm.hash.enabled

#NT Hashes for hashtopolis
cat log.ntds.users | cut -d : -f4 | sort -u > log.nt.hashes
