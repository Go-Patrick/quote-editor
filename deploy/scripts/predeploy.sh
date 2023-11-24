#!/bin/bash
source .env
docker-compose down -f /home/ec2-user/app/docker-compose.yml || echo "Fail"