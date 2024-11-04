#!/bin/bash

# Check if VPC ID is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <VPC_ID>"
    exit 1
fi

VPC_ID=$1
output_file="ec2_instance_details.csv"

# Write the CSV header
echo "InstanceID,PrivateIP,InstanceType,InstanceName,VolumeSize" > "$output_file"

# Get the list of EC2 instances in the specified VPC
aws ec2 describe-instances --filters "Name=vpc-id,Values=$VPC_ID" --query "Reservations[].Instances[].[InstanceId, PrivateIpAddress, InstanceType, Tags[?Key=='Name'].Value | [0], BlockDeviceMappings[].Ebs.VolumeId]" --output json | jq -c '.[]' | while read -r instance; do
    # Parse the JSON data for each instance
    instance_id=$(echo "$instance" | jq -r '.[0]')
    private_ip=$(echo "$instance" | jq -r '.[1]')
    instance_type=$(echo "$instance" | jq -r '.[2]')
    instance_name=$(echo "$instance" | jq -r '.[3]')
    
    # Get each EBS volume size attached to the instance
    volume_id=$(echo "$instance" | jq -r '.[4]')

    # Retrieve the EBS volume size
    volume_size=$(aws ec2 describe-volumes --volume-ids "$volume_id" --query "Volumes[].Size" --output text)

    # Append the data to the CSV file
    echo "$instance_id,$private_ip,$instance_type,$instance_name,$volume_size" >> "$output_file"
done

echo "EC2 instance details for VPC $VPC_ID have been saved to $output_file"
