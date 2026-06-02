#!/bin/bash
set -x

awslocal s3 mb s3://fuvekon-bucket

# Allow browser direct uploads (presigned PUT) from local frontends.
awslocal s3api put-bucket-cors --bucket fuvekon-bucket --cors-configuration '{
  "CORSRules": [
    {
      "AllowedHeaders": ["*"],
      "AllowedMethods": ["GET", "PUT", "POST", "HEAD"],
      "AllowedOrigins": ["http://localhost:3000", "http://localhost:3001"],
      "ExposeHeaders": ["ETag"],
      "MaxAgeSeconds": 3000
    }
  ]
}'

set +x