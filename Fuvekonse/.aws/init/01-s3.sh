#!/bin/bash
set -x

awslocal s3 mb s3://fuvekon-bucket || true
awslocal s3 mb s3://fuvekonse-bucket || true

set +x
