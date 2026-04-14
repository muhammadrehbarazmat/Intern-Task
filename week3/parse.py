import json
import os

# CONFIG
REQUIRED_KEYS = {
    "app_name": str,
    "port": int,
    "debug": bool
}


def load_config(file_path):
    try:
        with open(file_path, "r") as file:
            config = json.load(file)
        return config
    except Exception as e:
        print(f"Error reading config: {e}")
        return None

# validating keys
def validate_config(config):
    for key, expected_type in REQUIRED_KEYS.items():

        if key not in config:
            print(f"Missing key: {key}")
            return False

        if not isinstance(config[key], expected_type):
            print(f"Invalid type for {key}. Expected {expected_type.__name__}")
            return False

    return True


def main():
    # Get current script directory
    base_dir = os.path.dirname(os.path.abspath(__file__))

    config_path = os.path.join(base_dir, "config.json")

    # Load config
    config = load_config(config_path)

    if config is None:
        return

    if validate_config(config):
        print("Config is valid ")
    else:
        print("Config is invalid ")


if __name__ == "__main__":
    main()
