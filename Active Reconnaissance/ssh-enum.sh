#!/bin/bash
# Author: Prince Lassey

echo ""

if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter target for SSH Enumeration: " target
fi

mkdir -p results/$(echo $target | tr '/' '_')/

echo ""

echo "Starting SSH Enumeration on $target ..."

nmap -p 22 --script ssh2-enum-algos "$target" -oN "results/$(echo $target | tr '/' '_')/ssh-enum.txt" > /dev/null 2>&1

echo "========================================================================================="

echo "SSH Enumeration Complete. Check 'results' folder, results are saved in 'ssh-enum.txt'"

echo "========================================================================================="

