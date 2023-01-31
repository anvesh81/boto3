#!/bin/bash

# List of security groups
sec_groups=(sg-12345678 sg-23456789 sg-34567890)

# Ingress rule parameters
protocol="tcp"
port="22"
cidr="0.0.0.0/0"
description="Allow SSH access"

# Loop through each security group and add the ingress rule
for sec_group in "${sec_groups[@]}"
do
  aws ec2 authorize-security-group-ingress \
    --group-id "$sec_group" \
    --protocol "$protocol" \
    --port "$port" \
    --cidr "$cidr" \
    --description "$description"
done
