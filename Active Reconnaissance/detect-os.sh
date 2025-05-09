#!/bin/bash 

echo ""

if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter target to check OS information:" target
fi

mkdir -p results/$(echo "$target" | tr '/' '_')/

echo ""

echo "Starting OS Detection on $target... "

nmap -O "$target" -oN "results/$(echo "$target" | tr '/' '_')/detect-os.txt" > /dev/null 2>&1

echo "====================================================================================="

echo "OS Detection Complete. Check 'results' folder with results saved in 'detect-os.txt'"

echo "====================================================================================="
