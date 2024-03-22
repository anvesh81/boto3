#!/bin/bash

# Function to get FSx inventory
get_fsx_inventory() {
    aws fsx describe-file-systems --output json
}

# Function to write inventory to CSV
write_to_csv() {
    local file_systems=$1
    local file_name=$2

    # Define CSV header
    header="FileSystemId,DNSName,FileSystemType,CreationTime,LifeCycle,Size,Region,VpcId,SubnetIds"

    # Write header to CSV file
    echo "$header" > "$file_name"

    # Iterate over file systems and append data to CSV file
    for fs in $(echo "$file_systems" | jq -c '.FileSystems[]'); do
        file_system_id=$(echo "$fs" | jq -r '.FileSystemId')
        dns_name=$(echo "$fs" | jq -r '.DNSName // empty')
        fs_type=$(echo "$fs" | jq -r '.FileSystemType')
        creation_time=$(echo "$fs" | jq -r '.CreationTime')
        lifecycle=$(echo "$fs" | jq -r '.Lifecycle')
        size=$(echo "$fs" | jq -r '.StorageCapacity')
        region=$(echo "$fs" | jq -r '.Location.RegionName')
        vpc_id=$(echo "$fs" | jq -r '.VpcId')
        subnet_ids=$(echo "$fs" | jq -r '.SubnetIds | join(", ")')

        echo "$file_system_id,$dns_name,$fs_type,$creation_time,$lifecycle,$size,$region,$vpc_id,$subnet_ids" >> "$file_name"
    done
}

# Main function
main() {
    local file_systems=$(get_fsx_inventory)
    local file_name="fsx_inventory.csv"
    
    write_to_csv "$file_systems" "$file_name"
}

main
