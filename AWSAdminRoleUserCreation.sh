#!/bin/bash

# Define the role and user names
ROLE_NAME="ADMIN1"
USER1="USER1"
USER2="USER2"

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

# Create USER1 and USER2
aws iam create-user --user-name $USER1
aws iam create-user --user-name $USER2

# Attach the AWSCloudShellFullAccess policy to both users
aws iam attach-user-policy --user-name $USER1 --policy-arn arn:aws:iam::aws:policy/AWSCloudShellFullAccess
aws iam attach-user-policy --user-name $USER2 --policy-arn arn:aws:iam::aws:policy/AWSCloudShellFullAccess

# Generate access keys for USER1 and USER2
aws iam create-access-key --user-name $USER1
aws iam create-access-key --user-name $USER2

echo "Role $ROLE_NAME created with AdministratorAccess."
echo "Users $USER1 and $USER2 created with AWSCloudShellFullAccess policy and access keys."
