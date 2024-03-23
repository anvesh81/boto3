import boto3
import csv

def get_aws_account_id():
    """
    Retrieves the AWS account ID.
    """
    # Initialize Boto3 client for STS
    sts_client = boto3.client('sts')

    # Retrieve the AWS account ID associated with the credentials
    response = sts_client.get_caller_identity()
    account_id = response['Account']

    return account_id

def get_fsx_inventory():
    """
    Retrieves Amazon FSx inventory.
    """
    # Initialize Boto3 client for FSx
    fsx_client = boto3.client('fsx')

    # Retrieve list of FSx file systems
    response = fsx_client.describe_file_systems()

    # Extract relevant information from the response
    file_systems = response.get('FileSystems', [])

    inventory = []

    for fs in file_systems:
        file_system_id = fs.get('FileSystemId', '')
        file_system_type = fs.get('FileSystemType', '')
        creation_time = fs.get('CreationTime', '').strftime('%Y-%m-%d %H:%M:%S')
        storage_capacity = fs.get('StorageCapacity', 0)
        storage_type = fs.get('StorageType', '')
        throughput_capacity = fs.get('ThroughputCapacity', 0)
        dns_name = fs.get('DNSName', '')

        inventory.append({
            'FileSystemId': file_system_id,
            'FileSystemType': file_system_type,
            'CreationTime': creation_time,
            'StorageCapacity': storage_capacity,
            'StorageType': storage_type,
            'ThroughputCapacity': throughput_capacity,
            'DNSName': dns_name,
            'AWSAccountId': aws_account_id,  # Added AWS account ID
            'AWSAccountName': aws_account_name  # Added AWS account name
        })

    return inventory

def write_to_csv(data, filename='fsx_inventory.csv'):
    """
    Writes the FSx inventory data to a CSV file.
    """
    with open(filename, 'w', newline='') as csvfile:
        fieldnames = ['FileSystemId', 'FileSystemType', 'CreationTime', 'StorageCapacity', 'StorageType', 'ThroughputCapacity', 'DNSName', 'AWSAccountId', 'AWSAccountName']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for item in data:
            writer.writerow(item)

def main():
    # Retrieve AWS account ID
    aws_account_id = get_aws_account_id()

    # Input AWS account name
    aws_account_name = input("Enter AWS Account Name: ")

    fsx_inventory = get_fsx_inventory()
    write_to_csv(fsx_inventory)
    print("Amazon FSx inventory has been dumped into 'fsx_inventory.csv'")

if __name__ == "__main__":
    main()
