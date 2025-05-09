!#/bin/bash
echo "========================================================================="
figlet "Domain Passive Recon"
echo "========================================================================="

read -p "Enter domain/ip address to scan: " target

mkdir -p "$(echo "$target" | tr '/' '_') Passive Recon Results"

# WHOIS lookup
echo ""
echo "WHOIS Lookup is running :)"
whois "${target}" > "$(echo "$target" | tr '/' '_') Passive Recon Results/whois.txt"
echo "WHOIS Lookup Complete."

# Nslookup
echo ""
echo "Nslookup is running :) "
nslookup "${target}" > "$(echo "$target" | tr '/' '_') Passive Recon Results/nslookup.txt"
echo "Nslookup Complete"

# HOST lookup
echo ""
echo "HOST lookup is running :)"
host "$target" > "$(echo "$target" | tr '/' '_') Passive Recon Results/host.txt"
echo "HOST Lookup Complete"

# DIG lookup
echo ""
echo "DIG lookup is running :)"
dig "$target" any > "$(echo "$target" | tr '/' '_') Passive Recon Results/dig.txt"
echo "DIG Lookup Complete."

echo ""
# theHarvester 
cat << EOF
TheHarvester is running :)
Searching all public data...
Might take just some minutes..
EOF
theHarvester -d "$target" -b all 2>/dev/null > "$(echo "$target" | tr '/' '_') Passive Recon Results/Theharvester.txt"
echo "TheHarvester Scan Complete."

echo ""

echo "================================================================================="
echo "Recon Complete! Results are saved in '$(echo "$target" | tr '/' '_') Passive Recon Results' directory"
echo "================================================================================="
