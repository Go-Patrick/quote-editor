#!/bin/bash
aws cloudwatch put-metric-data --namespace "AWS/CodeDeploy" --metric-name "DeploymentStatus" --value 1 --dimensions "DeploymentGroupName=quote-group,ApplicationName=quote-editor"
source .source
echo ${ECR_TOKEN} | docker login --username AWS --password-stdin 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com
docker pull 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com/quote-app:${IMAGE_VERSION}
docker-compose up -f /home/ec2-user/app/docker-compose.yml -d