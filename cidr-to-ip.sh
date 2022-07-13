#!/bin/bash

nmap -sL -n -iL $1 | awk '/Nmap scan report/{print $NF}'
