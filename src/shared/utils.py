import yaml
import logging
import os
from cryptography.fernet import Fernet

def load_configuration(config_path='config/settings.yml'):
    """
    Load configuration settings from a YAML file.
    """
    try:
        with open(config_path, 'r') as file:
            config = yaml.safe_load(file)
            logging.info("Configuration loaded successfully.")
            return config
    except FileNotFoundError:
        logging.error(f"Configuration file not found: {config_path}")
        return {}
    except yaml.YAMLError as exc:
        logging.error(f"Error parsing configuration file: {exc}")
        return {}

def setup_logging(log_level=logging.INFO, log_file='logs/agent.log'):
    """
    Set up logging for the application.
    """
    os.makedirs(os.path.dirname(log_file), exist_ok=True)
    logging.basicConfig(
        level=log_level,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file),
            logging.StreamHandler()
        ]
    )
    logging.info("Logging is set up.")

def secure_data_handling(data, key=None):
    """
    Implement secure data handling practices, such as encryption.
    """
    if key is None:
        key = Fernet.generate_key()
        logging.info("Generated new encryption key.")
    
    fernet = Fernet(key)
    encrypted_data = fernet.encrypt(data.encode())
    logging.info("Data encrypted successfully.")
    return encrypted_data, key

def decrypt_data(encrypted_data, key):
    """
    Decrypt data using the provided key.
    """
    fernet = Fernet(key)
    decrypted_data = fernet.decrypt(encrypted_data).decode()
    logging.info("Data decrypted successfully.")
    return decrypted_data

def common_function():
    """
    A shared utility function.
    """
    logging.info("Executing a shared utility function.")
    print("This is a shared utility function")

def validate_environment_variables(required_vars):
    """
    Validate that all required environment variables are set.
    """
    missing_vars = [var for var in required_vars if os.getenv(var) is None]
    if missing_vars:
        logging.error(f"Missing environment variables: {', '.join(missing_vars)}")
        raise EnvironmentError(f"Missing environment variables: {', '.join(missing_vars)}")
    logging.info("All required environment variables are set.")