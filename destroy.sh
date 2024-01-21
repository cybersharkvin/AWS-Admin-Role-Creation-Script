#!/bin/bash

# Define the role and user names
ROLE_NAME1="ADMIN1"
ROLE_NAME2="ADMIN2"
USER1="LabUser1"
USER2="LabUser2"

# Function to delete a role
delete_role() {
    local role_name=$1

    # Detach all managed policies from the role
    for policy_arn in $(aws iam list-attached-role-policies --role-name $role_name --query 'AttachedPolicies[*].PolicyArn' --output text); do
        aws iam detach-role-policy --role-name $role_name --policy-arn $policy_arn
    done

    # Finally, delete the role
    aws iam delete-role --role-name $role_name
}

# Function to delete a user
delete_user() {
    local username=$1

    # List and delete user's access keys
    for key in $(aws iam list-access-keys --user-name $username --query 'AccessKeyMetadata[*].AccessKeyId' --output text); do
        aws iam delete-access-key --user-name $username --access-key-id $key
    done

    # Detach all managed policies from the user
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

# Delete roles
delete_role $ROLE_NAME1
delete_role $ROLE_NAME2

# Delete users
delete_user $USER1
delete_user $USER2

# Remove the script directory
rm -rf AWS-Admin-Role-Creation-Script/

echo "Roles $ROLE_NAME1 and $ROLE_NAME2, and users $USER1, $USER2 along with their policies and access keys have been deleted."
echo "AWS-Admin-Role-Creation-Script directory has been removed."
