#!/bin/bash

#Arg1 is ?????
#Arg 2 is ?????

while read -r line; do grep `echo $line | cut -d ":" -f1` $1; echo $line|cut -d ":" -f2  ; done < $2
