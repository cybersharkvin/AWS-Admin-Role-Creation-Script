#!/bin/bash

# Define the role and user names
ROLE_NAME1="ADMIN1"
ROLE_NAME2="ADMIN2"
USER1="LabUser1"
USER2="LabUser2"
COMMON_PASSWORD="iamaPassword3=-" # Updated common password for both users

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

# Create the roles with the trust policy
aws iam create-role --role-name $ROLE_NAME1 --assume-role-policy-document "$TRUST_POLICY"
aws iam create-role --role-name $ROLE_NAME2 --assume-role-policy-document "$TRUST_POLICY"

# Attach the AdministratorAccess policy to the roles
aws iam attach-role-policy --role-name $ROLE_NAME1 --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam attach-role-policy --role-name $ROLE_NAME2 --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Create LabUser1 and LabUser2
aws iam create-user --user-name $USER1
aws iam create-user --user-name $USER2

# Attach the AWSCloudShellFullAccess policy to both users
aws iam attach-user-policy --user-name $USER1 --policy-arn arn:aws:iam::aws:policy/AWSCloudShellFullAccess
aws iam attach-user-policy --user-name $USER2 --policy-arn arn:aws:iam::aws:policy/AWSCloudShellFullAccess

# Generate access keys for LabUser1 and LabUser2
aws iam create-access-key --user-name $USER1
aws iam create-access-key --user-name $USER2

# Create a login profile for LabUser1 and LabUser2 with the updated common password, without requiring a password reset
aws iam create-login-profile --user-name $USER1 --password $COMMON_PASSWORD --no-password-reset-required
aws iam create-login-profile --user-name $USER2 --password $COMMON_PASSWORD --no-password-reset-required

echo "Roles $ROLE_NAME1 and $ROLE_NAME2 created with AdministratorAccess."
echo "Users $USER1 and $USER2 created with AWSCloudShellFullAccess policy, access keys, and console access with updated password."
