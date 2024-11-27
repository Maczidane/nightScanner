# Night Automated Recon Script

## Overview
This script is an enhanced and revised version of the **@hmaverickadams scanner script**, designed to perform comprehensive reconnaissance tasks. It automates subdomain enumeration, live host probing, port scanning, and Wayback Machine data analysis for a given URL.

The tool is ideal for security professionals and bug bounty hunters looking for a streamlined approach to information gathering.

## Features
- **Directory Structure Automation**: Automatically creates and organizes output directories for easier navigation.
- **Subdomain Enumeration**: Uses `assetfinder` to identify subdomains.
- **Live Domain Probing**: Uses `httprobe` to identify live domains.
- **Subdomain Takeover Analysis**: Leverages `subjack` to detect vulnerable subdomains.
- **Port Scanning**: Uses `nmap` to scan live domains for open ports.
- **Wayback Machine Data Analysis**: Scrapes historical URLs and extracts useful parameters and file types.
- **Cleanup and Deduplication**: Ensures clean and sorted outputs for further analysis.

---

## Usage
### Prerequisites
Ensure the following tools are installed on your system:
- `assetfinder`
- `httprobe`
- `subjack`
- `nmap`
- `waybackurls`

### Running the Script
1. Save the script as `nightScanner.sh`.
OR
git clone https://github.com/maczidane/nightScanner.git

2. Make the script executable:
   ```bash
   chmod +x recon.sh
   ```
3. Run the script with a target URL:
   ```bash
   ./nightScanner.sh <url or IP>
   ```
   Example:
   ```bash
   ./nightScanner.sh example.com
   ```
    ```bash
   ./nightScanner.sh 8.8.8.8
   ```



## Output Structure
The script generates a structured directory for each target:
```
<url or IP>/
└── recon/
    ├── scans/
    ├── httprobe/
    │   └── alive.txt
    ├── potential_takeovers/
    │   └── potential_takeovers.txt
    ├── wayback/
    │   ├── wayback_output.txt
    │   ├── params/
    │   │   └── wayback_params.txt
    │   └── extensions/
    │       ├── js.txt
    │       ├── html.txt
    │       ├── json.txt
    │       ├── php.txt
    │       └── aspx.txt
    └── final.txt
```



## Script Workflow
1. **Setup Directory Structure**: Ensures a clean, organized workspace for results.
2. **Subdomain Enumeration**: Saves discovered subdomains to `recon/final.txt`.
3. **Live Domain Probing**: Outputs live domains to `recon/httprobe/alive.txt`.
4. **Subdomain Takeover Analysis**: Checks for takeover vulnerabilities.
5. **Port Scanning**: Scans live domains for open ports using `nmap`.
6. **Wayback Machine Data Analysis**: Saves historical URLs and extracts parameters/file types.
7. **Cleanup**: Deduplicates extracted data.


## Disclaimer
This script is intended for **authorized testing and educational purposes** only. Misuse of this tool for unauthorized activities may lead to legal consequences.



## Credits
- Original inspiration: **@hmaverickadams**
- Enhanced by: @maczidane



