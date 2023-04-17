@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo You must specify the region, e.g. us-east-1
    exit /b 1
)

aws --region=%1 ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-kernel-*-x86_64-gp2" "Name=state,Values=available" --output json | jq -r ".Images | sort_by(.CreationDate) | last(.[]).ImageId"

endlocal