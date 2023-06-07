#!/bin/bash/

mkdir -p summaries/
rm -f summaries/*

for file in xtmp/* 
do
	echo "Creating summary for $file"
	opt --thinlto-bc $file -o summaries/$(basename "$file")
done
