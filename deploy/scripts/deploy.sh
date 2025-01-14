#!/bin/bash
env_file="/home/ec2-user/app/.env"
source ${env_file}
export IMAGE_VERSION
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION
docker-compose -f /home/ec2-user/app/docker-compose.yml down || echo "Fail"

aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com
docker pull 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com/quote-app:"${IMAGE_VERSION}"
docker-compose -f /home/ec2-user/app/docker-compose.yml up -d