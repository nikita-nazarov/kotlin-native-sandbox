#!/bin/bash

mkdir -p dump/
rm -f dump/*

for file in ./tmp/*
do
	echo $file
	echo dump/$(basename "$file").txt
	llvm-bcanalyzer --dump $file > dump/$(basename "$file").txt
done

