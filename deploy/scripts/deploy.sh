#!/bin/bash

env_file="/home/ec2-user/app/.env"
source_file="/home/ec2-user/app/.source"
touch source_file
echo "" > "$source_file"
# Read each line from .env and export variables to .source
while IFS= read -r line; do
  # Extract key and value from each line
  key=$(echo "$line" | cut -d '=' -f 1)
  value=$(echo "$line" | cut -d '=' -f 2-)

  # Check if key and value are not empty
  if [ -n "$key" ] && [ -n "$value" ]; then
    echo "export $key=$value" >> "$source_file"
  fi
done < "$env_file"
source "${source_file}"
docker-compose down -f /home/ec2-user/app/docker-compose.yml || echo "Fail"

source .source
echo ${ECR_TOKEN} | docker login --username AWS --password-stdin 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com
docker pull 932782693588.dkr.ecr.ap-southeast-1.amazonaws.com/quote-app:${IMAGE_VERSION}
docker-compose up -f /home/ec2-user/app/docker-compose.yml -d