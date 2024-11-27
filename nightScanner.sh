#!/bin/bash
# Recon Automation Script
# Performs subdomain enumeration, live host probing, port scanning, and Wayback data analysis for a given URL.

# Ensure URL is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <url OR IP>"
    exit 1
fi

url=$1

# Function to create a directory if it doesn't exist
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "[+] Created directory: $1"
    fi
}

# Step 0: Setup directory structure
echo "[+] Setting up directory structure..."
create_dir "$url"
create_dir "$url/recon"
create_dir "$url/recon/scans"
create_dir "$url/recon/httprobe"
create_dir "$url/recon/potential_takeovers"
create_dir "$url/recon/wayback/params"
create_dir "$url/recon/wayback/extensions"

# Ensure placeholder files exist
touch "$url/recon/httprobe/alive.txt"
touch "$url/recon/final.txt"
touch "$url/recon/potential_takeovers/potential_takeovers.txt"

# Step 1: Subdomain Enumeration
echo "[+] Harvesting subdomains with assetfinder..."
assetfinder $url | grep $url | sort -u > "$url/recon/final.txt"
echo "[+] Subdomain enumeration complete. Results saved in $url/recon/final.txt"

# Step 2: Check for Live Domains
echo "[+] Probing for live domains using httprobe..."
cat "$url/recon/final.txt" | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' | sort -u > "$url/recon/httprobe/alive.txt"
echo "[+] Live domains saved in $url/recon/httprobe/alive.txt"

# Step 3: Subdomain Takeover Analysis
echo "[+] Checking for potential subdomain takeovers using subjack..."
subjack -w "$url/recon/final.txt" -t 100 -timeout 30 -ssl -c ~/go/src/github.com/haccer/subjack/fingerprints.json -v 3 -o "$url/recon/potential_takeovers/potential_takeovers.txt"
echo "[+] Subdomain takeover results saved in $url/recon/potential_takeovers/potential_takeovers.txt"

# Step 4: Port Scanning
echo "[+] Scanning for open ports using Nmap..."
nmap -iL "$url/recon/httprobe/alive.txt" -T4 -oA "$url/recon/scans/scanned"
echo "[+] Nmap scan complete. Results saved in $url/recon/scans/scanned"

# Step 5: Wayback Machine Data
echo "[+] Scraping Wayback Machine data for $url..."
cat "$url/recon/final.txt" | waybackurls | sort -u > "$url/recon/wayback/wayback_output.txt"
echo "[+] Wayback data saved in $url/recon/wayback/wayback_output.txt"

# Step 6: Extract Wayback Parameters
echo "[+] Extracting parameters from Wayback data..."
cat "$url/recon/wayback/wayback_output.txt" | grep '?*=' | cut -d '=' -f 1 | sort -u > "$url/recon/wayback/params/wayback_params.txt"
echo "[+] Parameters saved in $url/recon/wayback/params/wayback_params.txt"

# Step 7: Extract Specific File Types from Wayback Data
echo "[+] Extracting specific file types (e.g., js, php, json) from Wayback data..."
while read -r line; do
    ext="${line##*.}"
    case "$ext" in
        js|html|json|php|aspx)
            echo $line >> "$url/recon/wayback/extensions/$ext.txt"
            ;;
    esac
done < "$url/recon/wayback/wayback_output.txt"

# Step 8: Cleanup Duplicate Results
echo "[+] Removing duplicates in extracted files..."
for ext in js html json php aspx; do
    file="$url/recon/wayback/extensions/$ext.txt"
    if [ -f "$file" ]; then
        sort -u "$file" -o "$file"
        echo "[+] Processed $file"
    else
        echo "[-] File $file does not exist. Skipping..."
    fi
done

# Final Step: Recon Summary
echo "[+] Recon process completed for $url."
echo "Check results in the $url/recon/ directory."