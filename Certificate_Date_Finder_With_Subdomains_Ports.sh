output_file="scan_output.txt"  # Specify the output file name
timeout_duration=2

while read host; do
    while read port; do
        echo -e "\033[0;33mScanning ${host}:${port}\033[0m"
        output=$(echo | timeout "$timeout_duration" openssl s_client -connect "${host}:${port}" -servername "${host}" 2> /dev/null | openssl x509 -noout -dates)

        if echo "$output" | grep -q "notBefore\|notAfter"; then
            echo -e "\033[0;32m$output\033[0m"  # Green color for valid certificate dates
        elif ! echo "$output" | grep -q "Could not read certificate from <stdin>\|Unable to load certificate"; then
            echo "$output"  # Regular output
        fi

        echo -e "\n"
    done < portfile.txt
done < file.txt | tee -a "$output_file"  # Display and append output to the file

echo "Scan results saved to $output_file"

