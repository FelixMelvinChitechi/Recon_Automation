#!/bin/bash

# Recon & Enumeration Automation Script
# Author: felo
# For educational purposes only

TARGET=$1   # Example: google.com
TOOLS_DIR="/home/felo/Tools/ffuf"
OUTPUT_DIR="$TOOLS_DIR/recon_output"

mkdir -p "$OUTPUT_DIR"
cd "$TOOLS_DIR"

echo "[+] Starting recon for: $TARGET"

# Step 1: Subdomain Enumeration with Sublist3r
echo "[+] Running Sublist3r..."
sublist3r -d $TARGET -o "$OUTPUT_DIR/sublister.txt"

# Step 2: Test for live domains using httprobe
echo "[+] Checking live domains with httprobe..."
cat "$OUTPUT_DIR/sublister.txt" | httprobe > "$OUTPUT_DIR/live_subdomains.txt"

# Step 3: Directory bruteforce using dirb
echo "[+] Running Dirb on each live domain..."
while read url; do
    echo "[*] Scanning $url"
    dirb $url "$TOOLS_DIR/common.txt" -o "$OUTPUT_DIR/dirb_$(echo $url | sed 's~https\?://~~;s~/~-~g').txt"
done < "$OUTPUT_DIR/live_subdomains.txt"

# Step 4: Run LinkFinder on each live domain
# git clone https://github.com/GerbenJavado/LinkFinder.git
# cd LinkFinder
# python setup.py install
# pip3 install -r requirements.txt

echo "[+] Extracting JS endpoints with LinkFinder..."
cd "$TOOLS_DIR/LinkFinder"
while read url; do
    echo "[*] Running LinkFinder on $url"
    python3 linkfinder.py -i $url -d -o cli > "$OUTPUT_DIR/linkfinder_$(echo $url | sed 's~https\?://~~;s~/~-~g').txt"
done < "$OUTPUT_DIR/live_subdomains.txt"
cd "$TOOLS_DIR"

# Step 5: SocialHunter for broken link hijacking
# wget https://github.com/utkusen/socialhunter/releases/download/v0.1.1/socialhunter_0.1.1_Linux_amd64.tar.gz
# tar xzvf socialhunter_0.1.1_Linux_amd64.tar.gz

echo "[+] Running SocialHunter..."
./socialhunter -f "$OUTPUT_DIR/live_subdomains.txt" > "$OUTPUT_DIR/socialhunter.txt"

echo "[+] Recon completed! Results saved in: $OUTPUT_DIR"

