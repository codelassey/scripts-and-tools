#!/bin/bash
echo ""

if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter IP target for Port Scanning:" target
fi

mkdir -p results/$(echo "$target" | tr '/' '_')/

echo ""

echo "Starting Port Scan on $target... "

echo ""

nmap -Pn -p- "$target" -oN "results/$(echo "$target" | tr '/' '_')/port-scan.txt" > /dev/null 2>&1

echo "========================================================================================="

echo "Port Scan Complete. Check the results folder for scan results saved in 'port-scan.txt' "

echo "========================================================================================"
