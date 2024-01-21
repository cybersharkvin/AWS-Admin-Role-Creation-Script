#!/bin/bash

# Define the role and user names
ROLE_NAME="ADMIN1"
USER1="LabUser1"
USER2="LabUser2"

# Detach policy from the role
aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Delete the role
aws iam delete-role --role-name $ROLE_NAME

# Function to delete a user
delete_user() {
    local username=$1

    # List and delete user's access keys
    for key in $(aws iam list-access-keys --user-name $username --query 'AccessKeyMetadata[*].AccessKeyId' --output text); do
        aws iam delete-access-key --user-name $username --access-key-id $key
    done

    # Detach user policies
    for policy_arn in $(aws iam list-attached-user-policies --user-name $username --query 'AttachedPolicies[*].PolicyArn' --output text); do
        aws iam detach-user-policy --user-name $username --policy-arn $policy_arn
    done

    # Delete login profile if exists
    if aws iam get-login-profile --user-name $username 2>/dev/null; then
        aws iam delete-login-profile --user-name $username
    fi

    # Finally, delete the user
    aws iam delete-user --user-name $username
}

# Delete users
delete_user $USER1
delete_user $USER2

# Remove the script directory
rm -rf AWS-Admin-Role-Creation-Script/

echo "Role $ROLE_NAME and users $USER1, $USER2 along with their policies and access keys have been deleted."
echo "AWS-Admin-Role-Creation-Script directory has been removed."
