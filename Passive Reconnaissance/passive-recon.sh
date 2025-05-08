!#/bin/bash
figlet "Domain Passive Recon"

read -p "Enter domain/ip address to scan: " target

mkdir -p "${target} Passive Recon Results"

# WHOIS lookup
echo ""
echo "WHOIS Lookup is running :)"
whois "${target}" > "${target} Passive Recon Results/whois.txt"
echo "WHOIS Lookup Complete."

# Nslookup
echo ""
echo "Nslookup is running :) "
nslookup "${target}" > "${target} Passive Recon Results/nslookup.txt"
echo "Nslookup Complete"

# HOST lookup
echo ""
echo "HOST lookup is running :)"
host "$target" > "${target} Passive Recon Results/host.txt"
echo "HOST Lookup Complete"

# DIG lookup
echo ""
echo "DIG lookup is running :)"
dig "$target" any > "${target} Passive Recon Results/dig.txt"
echo "DIG Lookup Complete."

echo ""
# theHarvester 
cat << EOF
TheHarvester is running :)
Searching all public data...
Might take just some minutes..
EOF
theHarvester -d "$target" -b all 2>/dev/null > "${target} Passive Recon Results/Theharvester.txt"
echo "TheHarvester Scan Complete."

echo ""

echo "================================================================================="
echo "Recon Complete! Results are saved in '${target} Passive Recon Results' directory"
echo "================================================================================="
