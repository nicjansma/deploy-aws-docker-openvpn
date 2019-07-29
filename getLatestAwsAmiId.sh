!/usr/bin/env bash
## Quick call to get the latest AWS Linux 2 Quickstart AMI
## Requires region as only parameter
#
if [ "$1" != "" ]; then
    aws --region=$1 ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????-x86_64-gp2' 'Name=state,Values=available' --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
else
    echo "You must specify the region (us-east-1)"
fi

