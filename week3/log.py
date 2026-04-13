import re
from collections import Counter

LOG_FILE = "/var/log/syslog"

# Patterns
ip_pattern = r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'

# Counters
ip_counter = Counter()
service_counter = Counter()
error_counter = Counter()


def analyze_syslog(file_path):
    with open(file_path, 'r') as file:
        for line in file:

            # Extract service name
            match = re.search(r'(\w+)\[\d+\]:', line)
            if match:
                service = match.group(1)
                service_counter[service] += 1

            # Extract IP addresses
            ips = re.findall(ip_pattern, line)
            for ip in ips:
                ip_counter[ip] += 1

            # Detect errors
            if "error" in line.lower() or "failed" in line.lower():
                error_counter[line.strip()] += 1


def generate_report():
    print("\n===== SYSLOG ANALYSIS REPORT =====\n")

    print("Top 5 Services:")
    for service, count in service_counter.most_common(5):
        print(f"{service} -> {count} entries")

    print("\nTop 5 IP Addresses:")
    for ip, count in ip_counter.most_common(5):
        print(f"{ip} -> {count} times")

    print("\nTop 5 Errors:")
    for err, count in error_counter.most_common(5):
        print(f"{err} -> {count} times")

    print("\n END OF REPORT ")


if __name__ == "__main__":
    analyze_syslog(LOG_FILE)
    generate_report()
