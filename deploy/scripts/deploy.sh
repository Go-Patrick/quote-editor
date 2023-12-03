#!/bin/bash
mkdir /home/ec2-user/app/app.log >> /home/ec2-user/app/app.log


env_file="/home/ec2-user/app/.env"
source ${env_file}
export ECR_TOKEN
export IMAGE_VERSION
#docker-compose -f /home/ec2-user/app/docker-compose.yml down || echo "Fail"

echo ${ECR_TOKEN} | docker login --username AWS --password-stdin 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com >> /home/ec2-user/app/app.log
docker pull 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com/quote-app:${IMAGE_VERSION} >> /home/ec2-user/app/app.log
docker-compose -f /home/ec2-user/app/docker-compose.yml up -d >> /home/ec2-user/app/app.log