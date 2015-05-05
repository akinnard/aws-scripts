#!/bin/bash
# This script will loop through all your s3 buckets and give you the size of each in bytes You can add the math to convert to mb/gb/tb. I prefer to do that in excel after I generate this output
# This script assumes you have the aws cli installed and configured

# this variation breaks out the storage by class. This is so if you have glacier it shows it to you broken out

buckets=`aws s3 ls | cut -f3 -d ' '`
for x in $buckets ; do
	size=`echo -e "\`aws s3api list-objects --bucket $x --output text --query 'Contents[*].{SC:StorageClass, Size:Size}' |  awk '{sum[$1]+= $2;}END{for (s in sum){print "\n", s, "," ,sum[s], "&"}}'\`"` 
  while read -r -d'&' line; do
  	echo "$x , $line"
  done <<< $size
  
  
done
echo ""
