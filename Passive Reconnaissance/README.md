# DOMAIN RECON

A simple Bash script to automate passive reconnaissance for penetration testing and cybersecurity research.

## Features

- **WHOIS lookup**  
  Gathers registration details of the target domain/IP, including owner information, name servers, and contact details.

- **Nslookup**  
  Resolves domain names to IP addresses and retrieves basic DNS information.

- **Host lookup**  
  Provides detailed information about the DNS records associated with a domain, such as mail servers and name servers.

- **DIG DNS queries**  
  Performs advanced DNS queries to gather extensive DNS record information (A, MX, TXT, etc.).

- **theHarvester**  
  Harvests email addresses, subdomains, hosts, and employee names from public sources like search engines and databases.

- **dnsrecon**  
  Enumerates DNS records and zones, checks for DNS misconfigurations, and performs brute-forcing on DNS subdomains.

---

## Tools Required Before Running

Please ensure the following tools are installed on your system:

- **whois**
- **dnsutils** (for `nslookup`, `host`, `dig`)
- **theHarvester**
- **dnsrecon**

### Installation

```bash
# Update package lists
sudo apt update
```
```
# Install basic networking tools
sudo apt install whois dnsutils -y
```
```
# Install theHarvester and dnsrecon (if available)
sudo apt install theharvester dnsrecon -y
```

## How To Run
```
# Make the script executable
chmod +x osint_recon.sh
```
```
# Run the script
./osint_recon.sh
```
