#!/bin/bash
# Usage: aws_sso_inventory.sh <sso instance id>

sso_arn=arn:aws:sso:::instance/ssoins-${1}
mkdir psets account-assignments accounts customer-managed-policies managed-policies inline-policies permissions-boundaries
for i in $(aws sso-admin list-permission-sets --instance-arn "$sso_arn" \
    | jq -r '.PermissionSets[]'); do
    pset_id=${i##*-}

    aws sso-admin describe-permission-set \
        --instance-arn "$sso_arn" \
        --permission-set-arn "$i" > "psets/$pset_id"

    aws sso-admin list-accounts-for-provisioned-permission-set \
        --instance-arn "$sso_arn" \
        --permission-set-arn "$i" > "accounts/$pset_id"

    for acct in $(jq -r '.AccountIds[]' "accounts/$pset_id"); do
        aws sso-admin list-account-assignments \
            --instance-arn "$sso_arn" \
            --permission-set-arn "$i" --account-id "$acct" >> "account-assignments/${pset_id}-${acct}"
    done
    jq -s '{AccountAssignments: map(.AccountAssignments) | add}' "account-assignments/${pset_id}"-* \
        > "account-assignments/${pset_id}"

    aws sso-admin list-customer-managed-policy-references-in-permission-set \
        --instance-arn "$sso_arn" \
        --permission-set-arn "$i" > "customer-managed-policies/$pset_id"

    aws sso-admin list-managed-policies-in-permission-set \
        --instance-arn "$sso_arn" \
        --permission-set-arn "$i" > "managed-policies/$pset_id"

    aws sso-admin get-inline-policy-for-permission-set \
        --instance-arn "$sso_arn" \
        --permission-set-arn "$i" > "inline-policies/$pset_id"
done
