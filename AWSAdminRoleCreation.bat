#!/bin/bash

# Define the role name
ROLE_NAME="ADMIN1"

# Trust policy that allows all AWS IAM users to assume the role
TRUST_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "*"},
      "Action": "sts:AssumeRole"
    }
  ]
}'

# Create the role with the trust policy
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST_POLICY"

# Attach the AdministratorAccess policy to the role
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

echo "Role $ROLE_NAME created with AdministratorAccess."
