#!/bin/bash
set -x

if [ "${ENABLE_LOCALSTACK_LAMBDA:-0}" != "1" ]; then
  echo "Skipping Lambda deployment. Set ENABLE_LOCALSTACK_LAMBDA=1 to enable LocalStack Lambda dev setup."
  set +x
  exit 0
fi

sleep 2

ROLE_ARN="arn:aws:iam::000000000000:role/lambda-execution-role"

if [ -f "/tmp/lambda-services/general-service/bootstrap.zip" ]; then
  echo "Deploying general-service..."
  awslocal lambda create-function \
    --function-name general-service \
    --runtime provided.al2 \
    --role $ROLE_ARN \
    --handler bootstrap \
    --zip-file fileb:///tmp/lambda-services/general-service/bootstrap.zip \
    --timeout 30 \
    --memory-size 512 \
    --environment "Variables={DB_HOST=fuvekon-db,REDIS_HOST=fuvekon-cache,S3_BUCKET_URL=http://localstack:4566/fuvekon-bucket,SQS_QUEUE_URL=http://localstack:4566/000000000000/fuvekon-queue,PORT=8085}" \
    || echo "general-service Lambda already exists or failed to create"
  
else
  echo "general-service/bootstrap.zip not found - skipping"
fi

# Deploy rbac-service Lambda
if [ -f "/tmp/lambda-services/rbac-service/bootstrap.zip" ]; then
  echo "Deploying rbac-service..."
  awslocal lambda create-function \
    --function-name rbac-service \
    --runtime provided.al2 \
    --role $ROLE_ARN \
    --handler bootstrap \
    --zip-file fileb:///tmp/lambda-services/rbac-service/bootstrap.zip \
    --timeout 30 \
    --memory-size 512 \
    --environment "Variables={DB_HOST=fuvekon-db,REDIS_HOST=fuvekon-cache,S3_BUCKET_URL=http://localstack:4566/fuvekon-bucket,SQS_QUEUE_URL=http://localstack:4566/000000000000/fuvekon-queue,PORT=8081}" \
    || echo "rbac-service Lambda already exists or failed to create"

  echo "rbac-service deployed"
else
  echo "rbac-service/bootstrap.zip not found - skipping"
fi

# Deploy sqs-worker Lambda
if [ -f "/tmp/lambda-services/sqs-worker/bootstrap.zip" ]; then
  echo "Deploying sqs-worker..."
  awslocal lambda create-function \
    --function-name sqs-worker \
    --runtime provided.al2 \
    --role $ROLE_ARN \
    --handler bootstrap \
    --zip-file fileb:///tmp/lambda-services/sqs-worker/bootstrap.zip \
    --timeout 30 \
    --memory-size 512 \
    --environment "Variables={DB_HOST=fuvekon-db,REDIS_HOST=fuvekon-cache,SQS_QUEUE_URL=http://localstack:4566/000000000000/fuvekon-queue,USE_LOCALSTACK=true,AWS_REGION=ap-southeast-1}" \
    || echo "sqs-worker Lambda already exists or failed to create"

  echo "sqs-worker deployed"
else
  echo "sqs-worker/bootstrap.zip not found - skipping"
fi

echo "Lambda deployment completed"

awslocal lambda list-functions --query 'Functions[*].[FunctionName,Runtime,LastModified]' --output table

set +x
