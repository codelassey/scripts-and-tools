#!/bin/bash

# Author: Prince Lassey

echo ""

if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter target for FTP Enumeration: " target
fi

mkdir -p results/$(echo $target | tr '/' '_')/

echo ""

echo "Starting FTP Enumeration on $target ..."

nmap -p 21 --script ftp-anon "$target" -oN "results/$(echo $target | tr '/' '_')/ftp-enum.txt" > /dev/null 2>&1

echo "========================================================================================="

echo "FTP Enumeration Complete. Check 'results' folder, results are saved in 'ftp-enum.txt'"

echo "========================================================================================="
