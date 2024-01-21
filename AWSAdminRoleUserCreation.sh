#!/bin/bash

# Define the role, user names, and policy name
ROLE_NAME="ADMIN1"
USER1="LabUser1"
USER2="LabUser2"
COMMON_PASSWORD="iamaPassword$3" # Common password for both users
GET_SESSION_TOKEN_POLICY_NAME="GetSessionTokenPolicy"

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

# Policy that allows sts:GetSessionToken
GET_SESSION_TOKEN_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:GetSessionToken",
      "Resource": "*"
    }
  ]
}'

# Create the role with the trust policy
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST_POLICY"

# Attach the AdministratorAccess policy to the role
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Create LabUser1 and LabUser2
aws iam create-user --user-name $USER1
aws iam create-user --user-name $USER2

# Attach the AWSCloudShellFullAccess policy to both users
aws iam attach-user-policy --user-name $USER1 --policy-arn arn:aws:iam::aws:policy/AWSCloudShellFullAccess
aws iam attach-user-policy --user-name $USER2 --policy-arn arn:aws:iam::aws:policy/AWSCloudShellFullAccess

# Create custom policy for sts:GetSessionToken
aws iam create-policy --policy-name $GET_SESSION_TOKEN_POLICY_NAME --policy-document "$GET_SESSION_TOKEN_POLICY"

# Attach the custom GetSessionToken policy to both users
aws iam attach-user-policy --user-name $USER1 --policy-arn arn:aws:iam::aws:policy/$GET_SESSION_TOKEN_POLICY_NAME
aws iam attach-user-policy --user-name $USER2 --policy-arn arn:aws:iam::aws:policy/$GET_SESSION_TOKEN_POLICY_NAME

# Generate access keys for LabUser1 and LabUser2
aws iam create-access-key --user-name $USER1
aws iam create-access-key --user-name $USER2

# Create a login profile for LabUser1 and LabUser2 with a common password, without requiring a password reset
aws iam create-login-profile --user-name $USER1 --password $COMMON_PASSWORD --no-password-reset-required
aws iam create-login-profile --user-name $USER2 --password $COMMON_PASSWORD --no-password-reset-required

echo "Role $ROLE_NAME and users $USER1, $USER2 created with necessary policies and access."
