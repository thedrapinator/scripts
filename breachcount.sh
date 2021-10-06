#!/bin/bash

# ADD INSTALL COMMAND FOR PROGRAM USED

extension=`echo $1 | cut -d "." -f1`
countfile=$extension-breachcount.txt
touch $countfile


cat $1 | while read line 
do
   count=`pwned ba $line | grep Name | wc -l`
   echo "$line ($count)"
   echo "$line ($count)" >> $countfile
   sleep 2
done

