#!/bin/bash

# Usage: combine-ntlm.sh ntds.dit cracked.txt

while read -r line; do grep `echo $line | cut -d ":" -f1` $1; echo $line|cut -d ":" -f2  ; done < $2
