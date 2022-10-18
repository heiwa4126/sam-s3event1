#!/bin/bash -ue
. ./tmp_env.sh

aws s3 cp README.md "s3://$SO_TheS3BucketName"
