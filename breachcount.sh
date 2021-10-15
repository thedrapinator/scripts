#!/bin/bash

#INSTALL COMMAND FOR PROGRAM USED
#https://github.com/wKovacs64/pwned
#npm install pwned -g

echo "Add api key with command 'pwned apiKey <key>'"

extension=`echo $1 | cut -d "." -f1`
countfile=$extension-breachcount.txt
touch $countfile

cat $1 | while read line 
do
   pwned search $line > breach_temp.txt
   count=`cat breach_temp.txt | grep Name | wc -l`
   clear=`cat breach_temp.txt | grep Date | wc -l`
   date=`cat breach_temp.txt | grep Date | tail -1 | sed 's/ //g' | cut -d ":" -f2,3 | cut -d "T" -f1`
   echo "$line ($count) ($clear)* ($date)"
   echo "$line ($count) ($clear)* ($date)" >> $countfile
   rm breach_temp.txt
   sleep 3
done

echo "COMPLETED!! Data is stored in $countfile"
