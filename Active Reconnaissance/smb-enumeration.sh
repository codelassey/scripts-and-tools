#!/bin/bash

# Author: Prince Lassey

echo ""

if [ -n "$1" ]; then
    target="$1"
else
    read -p "Enter target address for SMB Enumeration: " target
fi

mkdir -p results/$(echo "target" | tr '/' '_')/

echo ""

echo "Starting SMB Enumeration on $target... "

enum4linux -a "$target"> "results/$(echo "target" | tr '/' '_')/smb-enum.txt" > /dev/null 2>&1

echo "==================================================================================================="

echo "SMB Enumeration Complete. Check the 'results' folder for your scan results saved in 'smb-enum.txt'"

echo "==================================================================================================="
