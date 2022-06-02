#!/bin/bash

#Variables
x=1
i=1
cat $1 > creds.tmp

until [ $x -lt 1 ]
do
 awk -F" " '!seen[$1]++' creds.tmp > spray$i.txt
 awk -F" " 'a[$1]++' creds.tmp > duplicates.tmp
 mv duplicates.tmp creds.tmp
 x=`cat creds.tmp | wc -l`
 ((i=i+1))
done

rm creds.tmp

echo "WROTE $i FILES :)"
