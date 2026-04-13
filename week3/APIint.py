import psutil
import requests
import time
import socket

# CONFIG
API_URL = "https://httpbin.org/post"
API_KEY = "your_api_key"
INTERVAL = 10  # seconds

# Get hostname
hostname = socket.gethostname()


def get_system_metrics():
    metrics = {
        "hostname": hostname,
        "cpu_usage": psutil.cpu_percent(interval=1),
        "memory_usage": psutil.virtual_memory().percent,
        "disk_usage": psutil.disk_usage('/').percent,
        "timestamp": int(time.time())
    }
    return metrics


def send_to_api(data):
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    try:
        response = requests.post(API_URL, json=data, headers=headers)
        print(f"Sent! Status: {response.status_code}")
    except Exception as e:
        print(f"Error sending data: {e}")


def main():
    while True:
        metrics = get_system_metrics()
        print(metrics)
        send_to_api(metrics)
        time.sleep(INTERVAL)


if __name__ == "__main__":
    main()
