#!/bin/bash

echo ""

if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter IP Subnet for Host Discovery (eg. 10.5.5.4/14): " target
fi

mkdir -p results/$(echo "$target" | tr '/' '_')/

echo ""

echo "Starting Host Discovery on $target... "

nmap -sn "$target" -oN "results/$(echo $target | tr '/' '_')/host-discovery.txt" > /dev/null 2>&1

echo "==================================================================================="

echo "Host Discovery Complete. Check the Results folder. Results is in 'host-discovery' "

echo "==================================================================================="
