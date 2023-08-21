#input file should be like lazyhacker22.blogspot.com:443
output_file="scan_output.txt"      # Specify the output file name
csv_output_file="scan_output.csv"  # Specify the CSV output file name
timeout_duration=2

# Function to perform the scanning
perform_scan() {
    host="$1"
    port="$2"
    output=$(echo | timeout "$timeout_duration" openssl s_client -connect "${host}:${port}" -servername "${host}" 2> /dev/null | openssl x509 -noout -dates)
    echo "$output"
}

# Clear any previous background jobs
wait

# Create or truncate the CSV output file and add headers
echo "Host,Port,notBefore,notAfter" > "$csv_output_file"

# Read domain and port pairs from the file
while IFS=',' read -r line; do
    line=$(echo "$line" | tr -d '[:space:]')
    host=$(echo "$line" | cut -d ':' -f 1)
    port=$(echo "$line" | cut -d ':' -f 2)

    # Perform the scan and capture the output
    output=$(perform_scan "$host" "$port")

    # Extract notBefore and notAfter dates from the output
    notBefore=$(echo "$output" | grep -oP "notBefore=\K.*")
    notAfter=$(echo "$output" | grep -oP "notAfter=\K.*")

    # Append the data to the CSV output file
    echo "$host,$port,$notBefore,$notAfter" >> "$csv_output_file"
done < domain_port_file.txt

echo "CSV scan results saved to $csv_output_file"
