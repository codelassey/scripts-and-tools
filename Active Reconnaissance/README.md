A collection of simple bash scripts that help you perform Active Reconnaissance during cybersecurity assessments.
Reconnaissance means gathering information about a target network, server, or website before attacking it.
## Requirements
You need to install the tools below before running any script.
```
sudo apt update
sudo apt install nmap figlet enum4linux gobuster whatweb -y
```

| File                    | What it does                                       |
| :---------------------- | :------------------------------------------------- |
| `active-recon.sh`       | Main script to run all recon steps automatically   |
| `host-discovery.sh`     | Find live hosts                                    |
| `port-scan.sh`          | Scan open ports                                    |
| `detect-os.sh`          | Detect the operating system of the target          |
| `service-detection.sh`  | Find which services (like HTTP, FTP) are running   |
| `smb-enumeration.sh`    | Scan SMB (Windows File Sharing) services           |
| `dir-bruteforce.sh`     | Discover hidden folders/files on websites          |
| `detect-web-server.sh`  | Find web server technologies (e.g., Apache, Nginx) |
| `vulnerability-scan.sh` | Check for known vulnerabilities                    |
| `ftp-enum.sh`           | Scan FTP servers                                   |
| `ssh-enum.sh`           | Scan SSH servers                                   |
| `results/`              | Where your scan results will be saved              |


