#!/bin/bash -ue
. ./tmp_env.sh

aws s3 rm "s3://$SO_TheS3BucketName/README.md"
