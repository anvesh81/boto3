#!/bin/bash

# Set the list of IPs to check against
IP_LIST=("10.0.0.1/32" "10.0.0.2/32" "10.0.0.3/32")

# Get a list of all security group IDs
SG_IDS=$(aws ec2 describe-security-groups --query 'SecurityGroups[].GroupId' --output text)

# Loop through each security group
for SG_ID in $SG_IDS
do
  # Get a list of inbound rules for the security group
  INBOUND_RULES=$(aws ec2 describe-security-groups --group-id $SG_ID --query 'SecurityGroups[].IpPermissions[].IpRanges[].CidrIp' --output text)

  # Loop through each IP in the list
  for IP in ${IP_LIST[@]}
  do
    # Check if the IP is in the list of inbound rules
    if [[ " ${INBOUND_RULES[@]} " =~ " ${IP} " ]]; then
      # Remove the inbound rule from the security group
      aws ec2 revoke-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr $IP

      # Print the security group ID
      echo "Removed rule from Security Group: $SG_ID"
    fi
  done
done
