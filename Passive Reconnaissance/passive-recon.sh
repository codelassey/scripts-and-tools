#!/bin/bash
# I’m creating this script to automate passive reconnaissance on a domain or IP using multiple tools.

echo "========================================================================="
# visual separator to make the output look clean and professional.

figlet "Domain Passive Recon"
# I’m using figlet to display a fancy "Domain Passive Recon" banner for a cool, engaging start.

echo "========================================================================="
# Another separator to frame the banner nicely.

# This prompt ensures I always provide a target.
read -p "Enter domain/ip address to scan: " target

# I need a directory to store all the results, named after the target.
# The tr command replaces slashes (in URLs) with underscores to avoid invalid folder names.
# The -p flag ensures mkdir doesn’t error if the directory already exists.
mkdir -p "$(echo "$target" | tr '/' '_') Passive Recon Results"

# WHOIS lookup
echo ""
# A blank line for readability before starting the WHOIS lookup.
echo "WHOIS Lookup is running :)"

# I’m running a WHOIS lookup to gather domain registration details.
whois "${target}" > "$(echo "$target" | tr '/' '_') Passive Recon Results/whois.txt"
echo "WHOIS Lookup Complete."

# Nslookup
echo ""
# Another blank line to keep the output clean.
echo "Nslookup is running :) "
# using nslookup to get DNS information about the target.

nslookup "${target}" > "$(echo "$target" | tr '/' '_') Passive Recon Results/nslookup.txt"
echo "Nslookup Complete"


# HOST lookup
echo ""
# A blank line for readability before the host command.

echo "HOST lookup is running :)"

# I’m running the host command to find DNS records.
host "$target" > "$(echo "$target" | tr '/' '_') Passive Recon Results/host.txt"
echo "HOST Lookup Complete"
# I confirm completion for clarity.

# DIG lookup
echo ""

echo "DIG lookup is running :)"
# using dig with the 'any' option to pull all available DNS records and save them to the dig.txt file.
dig "$target" any > "$(echo "$target" | tr '/' '_') Passive Recon Results/dig.txt"

echo "DIG Lookup Complete."

# Subfinder
echo ""

echo "Enumerating Subdomains"

# I run Subfinder to discover subdomains passively.
# tr changes / to _ if a url was provided to avoid errors in directory naming.
echo "SUBDOMAINS FOUND" > "$(echo "$target" | tr '/' '_') Passive Recon Results/subfinder.txt"
echo "================" >> "$(echo "$target" | tr '/' '_') Passive Recon Results/subfinder.txt"
echo "" >> "$(echo "$target" | tr '/' '_') Passive Recon Results/subfinder.txt"

# I redirect Subfinder’s output to the file and suppress terminal output for a clean experience.

subfinder -d "$target" -o "$(echo "$target" | tr '/' '_') Passive Recon Results/subfinder.txt" > /dev/null 2>&1

echo "Subfinder Enumeration Complete."


echo ""


# theHarvester is used to gather public data (emails, hosts, etc.) from multiple sources.
# it takes a few minutes since it queries multiple sources.

cat << EOF
TheHarvester is running :)
Searching all public data...
Might take just some minutes..
EOF

# -b all queries all available sources
# I suppress terminal output to avoid clutter, as some sources may error without API keys.
theHarvester -d "$target" -b all 2>/dev/null > "$(echo "$target" | tr '/' '_') Passive Recon Results/Theharvester.txt"

echo "TheHarvester Scan Complete."

echo ""

echo "================================================================================="
echo ""
echo "Recon Complete! Results are saved in '$(echo "$target" | tr '/' '_') Passive Recon Results' directory"
echo "" 
echo "================================================================================="

