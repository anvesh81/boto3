import boto3

# Define the security group IDs
security_group_ids = ['sg-12345678', 'sg-87654321', 'sg-11223344']

# Define the ingress rules
ingress_rules = [
    {
        'FromPort': 3389,
        'ToPort': 3389,
        'IpProtocol': 'tcp',
        'IpRanges': [
            {
                'CidrIp': '0.0.0.0/0',
                'Description': 'RDP Access'
            }
        ]
    },
    {
        'FromPort': 443,
        'ToPort': 443,
        'IpProtocol': 'tcp',
        'IpRanges': [
            {
                'CidrIp': '0.0.0.0/0',
                'Description': 'SSL Access'
            }
        ]
    },
    {
        'FromPort': 1433,
        'ToPort': 1433,
        'IpProtocol': 'tcp',
        'IpRanges': [
            {
                'CidrIp': '0.0.0.0/0',
                'Description': 'SQL Access'
            }
        ]
    }
]

# Connect to EC2
ec2 = boto3.client('ec2')

# Loop through the security group IDs
for security_group_id in security_group_ids:
    # Loop through the ingress rules
    for ingress_rule in ingress_rules:
        # Add the ingress rule to the security group
        ec2.authorize_security_group_ingress(
            GroupId=security_group_id,
            IpPermissions=[ingress_rule]
        )

# Print a message to indicate that the ingress rules have been added successfully
print('Ingress rules added successfully')
