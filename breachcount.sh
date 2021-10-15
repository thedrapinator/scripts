#!/bin/bash

#INSTALL COMMAND FOR PROGRAM USED
#https://github.com/wKovacs64/pwned
npm install pwned -g

echo "Add api key with command 'pwned apiKey <key>'"

extension=`echo $1 | cut -d "." -f1`
countfile=$extension-breachcount.txt
touch $countfile

cat $1 | while read line 
do
   count=`pwned ba $line | grep Name | wc -l`
   sleep 2
   clear=`pwned pa $line | grep Date | wc -l`
   echo "$line ($count) ($clear)*"
   echo "$line ($count) ($clear)*" >> $countfile
   sleep 2
done

echo "COMPLETED!! Data is stored in $countfile"
