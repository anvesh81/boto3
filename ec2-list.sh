import boto3

def check_and_remove_security_group_rules():
    # Create a boto3 client for EC2
    ec2 = boto3.client('ec2')

    # Define the IPs to look for
    ips_to_check = ['172.25.200.13/32', '172.25.200.11/32']

    # Get all security groups
    security_groups = ec2.describe_security_groups()

    # Loop through all security groups
    for group in security_groups['SecurityGroups']:
        # Loop through all inbound rules
        for rule in group['IpPermissions']:
            # Check if the rule has the IPs we are looking for
            if any(ip in rule['IpRanges'] for ip in ips_to_check):
                # Remove the rule from the security group
                ec2.revoke_security_group_ingress(
                    GroupId=group['GroupId'],
                    IpPermissions=[rule]
                )
                # Print the security group ID
                print('Removed rule from security group:', group['GroupId'])
