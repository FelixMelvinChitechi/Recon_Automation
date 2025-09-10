# Recon_Automation
a bash script that chains all your recon and enumeration steps together. I’ll also include comments where installations would normally go, but focus only on execution.
Create the script file
nano recon.sh

Make it executable
chmod +x recon.sh

Run the script with a domain
./recon.sh google.com

Outputs will be stored in
/home/felo/Tools/ffuf/recon_output/

sublister.txt → raw subdomains

live_subdomains.txt → filtered live domains

dirb_*.txt → directory brute force results

linkfinder_*.txt → JS endpoints found

socialhunter.txt → broken link hijacking results
