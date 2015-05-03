#!/bin/bash
# This script will loop through all your s3 buckets and give you the size of each in bytes You can add the math to convert to mb/gb/tb. I prefer to do that in excel after I generate this output
# This script assumes you have the aws cli installed and configured

buckets=`aws s3 ls | cut -f3 -d ' '`

for x in $buckets ; do
  size=`aws s3 --output table ls s3://$x --recursive  | grep -v -E "(Bucket: |Prefix: |LastWriteTime|^$|--)" | awk 'BEGIN {total=0}{total+=$3}END{print total}'`
  echo "$x - $size"
done
echo ""