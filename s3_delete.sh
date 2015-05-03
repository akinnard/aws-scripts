#!/bin/bash
# Created by Allen Kinnard @tholinar
# This script is designed to work on a Mac. There are other linux examples available on the web.
# You must have the aws cli installed and configured with your keys. aws --configure
# This script will loop over every file in your folder and delete any file older or equal to the date passed in.
# You can set a limit on the number of files skipped before stopping

# usage:
# ./s3_delete.sh "<bucket/folder>" "<date yyyy-mm-dd>" <# skips before break -- optional >




scnt=1

# add training / if missing from bucket
lastbucket=`echo $1 | cut -c $((${#1}))`
if [[ $lastbucket == '/' ]]
	then 
	bucket="s3://$1"
else 
	bucket="s3://$1/"
fi

aws s3 ls s3://$1 | while read -r line;  do
	echo "-----------------"
	origdate=`echo $line|awk {'print $1" "$2'}`
	createdate=`echo $line|awk {'print $1'}`
	echo $line
	createdate=`date -jf '%Y-%m-%d' "$createdate" +%s`
	checkdate=`date -jf '%Y-%m-%d' "$2" +%s`
	if [[ $createdate -le $checkdate ]]
	  then 
	  	scnt=1
	    fileName=`echo $line|awk {'print $4'}`
	    uri="$bucket$fileName"
	    echo "delete file: $fileName"
	    if [[ $fileName != "" ]]
	      then
	        aws s3 rm "$uri"
	    fi
	else
		echo "Skipping file"
		if [[ $scnt == 10 && -n "$3" ]]
			then
			echo "Max skipped records reached"
			break
		else
			scnt=$((scnt + 1))
		fi
	fi
done;
