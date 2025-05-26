#!/bin/bash

# Author: Prince Lassey
echo ""
read -p "Enter target address: " target
chmod +x *.sh
echo "======================================================================="
figlet "Active Recon Suit"
echo "======================================================================="

echo ""
bash host-discovery.sh "target"

echo ""
bash port-scan.sh "target"

echo ""
bash detect-os.sh "target"

echo ""
bash service-detection.sh "target"

echo ""
bash smb-enumeration.sh "target"

echo ""
bash dir-bruteforce.sh "target"

echo ""
bash detect-web-server.sh "target"

#echo ""
#bash vulnerability-scan.sh "target"

echo ""
bash ftp-enum.sh "target"

echo ""
bash ssh-enum.sh "target"

echo ""
echo "==================================================================="
echo ""
echo "Active Recon Complete. View results in 'results' folder"
echo ""
echo "==================================================================="
