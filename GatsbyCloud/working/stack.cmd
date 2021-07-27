@echo off
set AWS_PROFILE=temp
if "%1" == "createstack" goto createstack
if "%1" == "deletestack" goto deletestack
if "%1" == "creates3" goto creates3
if "%1" == "deletes3" goto deletes3
if "%1" == "upload" goto upload
if "%1" == "cleanup" goto cleanup
:createstack
if "%2" == "" set stack=mystack
aws cloudformation create-stack --stack-name "%stack%" --template-body file://main.yaml --parameters file://main_dev_parameters.json --capabilities CAPABILITY_NAMED_IAM
goto end
:deletestack
if "%2" == "" set stack=mystack
aws cloudformation delete-stack --stack-name "%stack%"
goto end
:creates3
aws s3 mb s3://duobank-dev-infra-bucket-17f505d6-5f9a-4c24-8434-a31d9a10f61d
goto end
:deletes3
aws s3 rb s3://duobank-dev-infra-bucket-17f505d6-5f9a-4c24-8434-a31d9a10f61d --force
goto end
:upload
aws s3 cp ./ s3://duobank-dev-infra-bucket-17f505d6-5f9a-4c24-8434-a31d9a10f61d/cfn_template_gatsbycloud --exclude "*" --include "gatsbycloud_cloudfront_policy.yaml" --include "iam-group.yaml" --recursive
goto end
:cleanup
if "%2" == "" set stack=mystack
aws cloudformation delete-stack --stack-name "%stack%"
goto deletes3
:end