#!/bin/bash

# Specify input and output file names
input_file="domain_port_file.txt"
csv_output_file="scan_output.csv"

# Function to check certificate expiration
check_certificate() {
    domain="$1"
    port="$2"
    output=$(openssl s_client -servername "$domain" -connect "$domain":"$port" -showcerts </dev/null 2>/dev/null | openssl x509 -noout -dates)
    if [ $? -eq 0 ]; then
        not_before=$(echo "$output" | grep "notBefore" | cut -d= -f2)
        not_after=$(echo "$output" | grep "notAfter" | cut -d= -f2)
        
        # Convert dates to IST time zone
        not_before_ist=$(TZ=Asia/Kolkata date -d "$not_before" +"%b %d %H:%M:%S %Y")
        not_after_ist=$(TZ=Asia/Kolkata date -d "$not_after" +"%b %d %H:%M:%S %Y")
        
        today=$(date +%s)
        not_after_unix=$(date -d "$not_after" +%s)
        
        if [ "$today" -gt "$not_after_unix" ]; then
            status="Certificate Expired"
        else
            status="Certificate Valid"
        fi
        
        echo "$domain,$port,$not_before_ist,$not_after_ist,$status"
    else
        echo "$domain,$port,ERROR,ERROR,Certificate Error"
    fi
}

# Create or truncate the CSV output file and add headers
echo "Domain,Port,NotBefore,NotAfter,Status" > "$csv_output_file"

# Read domain and port pairs from the input file and process each one
while IFS=: read -r domain port; do
    echo "Checking certificate for: $domain"
    result=$(check_certificate "$domain" "$port")
    echo "$result" >> "$csv_output_file"
done < "$input_file"

echo "Scan results saved to $csv_output_file"
