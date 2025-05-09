#!/bin/bash

echo ""
if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter URL for Directory Bruteforcing:" target
fi

mkdir -p results

echo ""

echo "Starting Directory Bruteforce on $target... "

gobuster dir -u "$target" -w /usr/share/wordlists/dirb/common.txt -o  "results/$(echo $target | tr '/' '_')dir-bruteforce.txt" > /dev/null 2>&1

echo "=========================================================================================================="

echo "Directory Bruteforcing Complete. Check 'results' folder for scan results saved in 'dir-bruteforce.txt'"

echo "=========================================================================================================="

