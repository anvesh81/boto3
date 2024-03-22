import boto3
import csv

def get_fsx_inventory():
    # Initialize Boto3 AWS FSx client
    fsx_client = boto3.client('fsx')

    # Retrieve information about all FSx file systems
    response = fsx_client.describe_file_systems()

    return response['FileSystems']

def write_to_csv(file_systems, file_name):
    # Define CSV header
    header = ['FileSystemId', 'DNSName', 'FileSystemType', 'CreationTime', 'LifeCycle', 'Size', 'Region', 'VpcId', 'SubnetIds']

    # Write data to CSV file
    with open(file_name, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=header)
        writer.writeheader()
        for fs in file_systems:
            writer.writerow({
                'FileSystemId': fs['FileSystemId'],
                'DNSName': fs.get('DNSName', ''),
                'FileSystemType': fs['FileSystemType'],
                'CreationTime': fs['CreationTime'],
                'LifeCycle': fs['Lifecycle'],
                'Size': fs['StorageCapacity'],
                'Region': fs['Location']['RegionName'],
                'VpcId': fs['VpcId'],
                'SubnetIds': ', '.join(fs['SubnetIds'])
            })

def main():
    # Get FSx inventory
    file_systems = get_fsx_inventory()

    # Write inventory to CSV
    write_to_csv(file_systems, 'fsx_inventory.csv')

if __name__ == "__main__":
    main()
