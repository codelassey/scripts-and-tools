#!/bin/bash

echo ""

if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter target address for Service Detection:" target
fi

mkdir -p results/$(echo "$target" | tr '/' '_')/

echo ""

echo "Starting Service Detection on $target... "

echo ""

nmap -sV "$target" -oN "results/$(echo "$target" | tr '/' '_')/service-detection.txt" > /dev/null 2>&1

echo "======================================================================================================="

echo "Service Detection Complete. Check 'results' folder for scan results..saved in 'service-detection.txt'"

echo "======================================================================================================="
