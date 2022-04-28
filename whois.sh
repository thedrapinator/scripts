#!/bin/bash

#Create file with IP's in scope named inscope.txt
#Run script with no arguments
#Run script with company names and script will sort in scope IP to folders

threads=10

function maxrun {
   while [ $(jobs | wc -l) -ge $threads ]
   do
      sleep 1
   done
}

datapath=./whoisdata
mkdir -p $datapath

if [ $# -eq 0 ]
  then
    while read ip
    do 
      maxrun; echo "$ip RUNNING"; whois $ip > $datapath/$ip.txt &
    done < inscope.txt
    wait
  else
for f in $datapath/*.txt
  do
    #echo "Filename is $f"
    IP=`echo $f | rev | cut -d "/" -f1 | cut -d "." -f2,3,4,5 | rev`
    count=`cat $f | grep -i "$1" | wc -l`
    echo "$IP $1 $count"
    if [ $count -ge 1 ]
    then
      echo "MOVING VALIDATED IP $IP to $1 folder..."
      mkdir -p "$datapath/$1"
      mv $f "$datapath/$1"
    fi
  done
  
  #Count remaining
  remaining=`ls $datapath/*.txt | wc -l`
  echo "$remaining RECORDS REMAINING!"
fi
