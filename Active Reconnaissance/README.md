A collection of simple bash scripts that help you perform Active Reconnaissance during cybersecurity assessments.
Reconnaissance means gathering information about a target network, server, or website before attacking it.

![Image](https://github.com/user-attachments/assets/74cda4de-0f91-489e-967e-e6eeec9fd440)

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

## How To Run
Clone the repository
```
git clone https://github.com/codelassey/scripts-and-tools.git
cd Active\ Reconnaissance/
```

Make the scripts executable
```
sudo su
```
```
chmod +x *.sh
```

Run the script of your choice depending on what you want
```
#This script will run all the scripts at once
bash active-recon.sh <target>
```
or
``` bash active-recon.sh ``` and you will be asked for the target afterwards.

Example: ```bash active-recon.sh 127.0.0.1 ``` or ```bash active-recon.sh```

Individual Scripts
```
bash <script name> <target>
```
or
```
bash <script name>
```
and you will be asked for the target afterwards.

Example: ```bash port-scan.sh 127.0.0.1``` or ```bash port-scan.sh```
