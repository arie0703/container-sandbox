#!/bin/bash

aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${ECR_URI}
# for Mac OS (M1)
docker build -t nrflex-ecs --platform amd64 .
docker tag nrflex-ecs:latest ${ECR_URI}/nrflex-ecs:latest
docker push ${ECR_URI}/nrflex-ecs:latest
