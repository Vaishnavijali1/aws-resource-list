#!/bin/bash

###############################################################################
# Author: Jaliparthi Vaishnavi
# Date: 2024-06-10
# Version: v0.0.1

# Script to automate the process of listing all the resources in an AWS account
#
# Below are the services that are supported by this script:
# 1. EC2
# 2. RDS
# 3. S3
# 4. CloudFront
# 5. VPC
# 6. IAM
# 7. Route53
# 8. CloudWatch
# 9. CloudFormation
# 10. Lambda
# 11. SNS
# 12. SQS
# 13. DynamoDB
# 14. VPC
# 15. EBS
#
# The script will prompt the user to enter the AWS region and the service for which the resources need to be listed.
#
# Usage: ./aws_resource_list.sh  <aws_region> <aws_service>
# Example: ./aws_resource_list.sh us-east-1 ec2
#############################################################################

# Check if the required number of arguments are passe
# #!/bin/bash

# ==============================
# AWS Resource Listing Script
# ==============================
# Usage:
#   ./aws_resource_list.sh <region> <service>
# Example:
#   ./aws_resource_list.sh us-east-1 ec2
# ==============================

region=$1
service=$2

if [ -z "$region" ] || [ -z "$service" ]; then
  echo "Usage: $0 <region> <service>"
  echo "Example: $0 us-east-1 ec2"
  exit 1
fi

echo "------------------------------------------"
echo "Listing AWS $service resources in region: $region"
echo "------------------------------------------"

case $service in

  ec2)
    aws ec2 describe-instances \
      --region $region \
      --query "Reservations[].Instances[].{InstanceID:InstanceId, Name:Tags[?Key=='Name']|[0].Value, State:State.Name, Type:InstanceType, AZ:Placement.AvailabilityZone, PublicIP:PublicIpAddress}" \
      --output table
    ;;

  s3)
    aws s3api list-buckets \
      --query "Buckets[*].{Name:Name,CreationDate:CreationDate}" \
      --output table
    ;;

  rds)
    aws rds describe-db-instances \
      --region $region \
      --query "DBInstances[*].{DBInstanceIdentifier:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus,Endpoint:Endpoint.Address}" \
      --output table
    ;;

  lambda)
    aws lambda list-functions \
      --region $region \
      --query "Functions[*].{FunctionName:FunctionName,Runtime:Runtime,LastModified:LastModified}" \
      --output table
    ;;

  iam)
    aws iam list-users \
      --query "Users[*].{UserName:UserName,CreateDate:CreateDate,UserId:UserId}" \
      --output table
    ;;

  *)
    echo "Invalid service. Supported services are: ec2, s3, rds, lambda, iam"
    ;;
esac
