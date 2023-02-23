#!/bin/bash

# Define the CSV file to store the output
csv_file="ec2_instances.csv"

# Define the header row for the CSV file
header="Instance_ID,Instance_Name,Private_IP"

# Write the header row to the CSV file
echo $header > $csv_file

# Get the list of EC2 instances and their associated tags
instance_data=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],PrivateIpAddress]' --output text)

# Loop through the instance data and write it to the CSV file
while read -r line; do
  echo $line >> $csv_file
done <<< "$instance_data"

# Display a message to indicate that the output has been saved to the CSV file
echo "Instance data has been saved to $csv_file"
#######
# Set password length
$length = 16

# Generate a random password
$characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+"
$password = -join ((Get-Random -InputObject $characters -Count $length))

# Set new password for user account
Set-ADAccountPassword -Identity "Username" -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force)

# Print the new password
Write-Host "New password: $password"
