import requests
import csv
import concurrent.futures

def check_status_code(url):
    try:
        response = requests.get(url, timeout=10)
        return response.status_code
    except requests.exceptions.RequestException:
        return None

def process_domain(domain):
    http_url = f"http://{domain}"
    https_url = f"https://{domain}"

    http_status_code = check_status_code(http_url)
    https_status_code = check_status_code(https_url)

    print(f"Domain: {domain}")
    print(f"HTTP Status Code: {http_status_code}")
    print(f"HTTPS Status Code: {https_status_code}")
    print("------")

    return [domain, http_status_code, https_status_code]

def main():
    input_file_path = input("Enter the file path containing domain names: ")
    output_file_path = input("Enter the output CSV file path: ")

    with open(input_file_path, "r") as input_file, open(output_file_path, "w", newline='') as output_file:
        csv_writer = csv.writer(output_file)
        csv_writer.writerow(["Domain", "HTTP Status Code", "HTTPS Status Code"])

        domains = [domain.strip() for domain in input_file]

        with concurrent.futures.ThreadPoolExecutor() as executor:
            results = executor.map(process_domain, domains)

        for result in results:
            csv_writer.writerow(result)

    print(f"CSV file '{output_file_path}' has been created with the results.")

if __name__ == "__main__":
    main()
