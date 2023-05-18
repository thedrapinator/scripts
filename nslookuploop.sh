#!/bin/bash

while read IP ; do

        LOOKUP_RES=$(nslookup $IP | sed -n 's/.*arpa.*name = \(.*\)/\1/p')
        test -z "$LOOKUP_RES" && LOOKUP_RES="Failed"

        echo -e "$IP\t$LOOKUP_RES"

done < $1
