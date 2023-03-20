#!/bin/bash/

alias llvm-lto="/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto"

DIRS=("promoted" "imported" "internalised" "optimised")
for dir in ${DIRS[@]}
do
	mkdir -p $dir
	rm -f $dir/*
done

sh summaries.sh

echo "Thin linking summaries"
llvm-lto --thinlto-action=thinlink summaries/* -o index.bc	
	
#for file in summaries/* 
#do
#	echo "Promoting $file"
#	llvm-lto --thinlto-action=promote $file --thinlto-index=index.bc -o promoted/$(basename "$file") &
#done
#wait

#echo "Promoting"
#/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=promote summaries/* --thinlto-index=index.bc
#mv summaries/*thinlto* promoted/
#for file in promoted/*; do mv "${file}" "${file//\.thinlto.promoted.bc/}"; done

#for file in summaries/* 
#do
#	echo "Internalising $file"
#	llvm-lto --thinlto-action=internalize $file  --thinlto-index=index.bc -o internalised/$(basename "$file") &
#done
#wait


# echo "Internalising"
# /Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=internalize summaries/* --thinlto-index=index.bc --exported-symbol=_LONG_RANGE_TO
# mv summaries/*thinlto* internalised/
# for file in internalised/*; do mv "${file}" "${file//\.thinlto.internalized.bc/}"; done


#for file in promoted/* 
#do
#	echo "Importing $file"
#	llvm-lto --thinlto-action=import $file --thinlto-index=index.bc -o imported/$(basename "$file") &
#done
#wait

echo "Importing"
/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=import summaries/* --thinlto-index=index.bc
mv summaries/*thinlto* imported/
for file in imported/*; do mv "${file}" "${file//\.thinlto.imported.bc/}"; done

for file in imported/* 
do
	echo "Optimizing $file"
	llvm-lto --thinlto-action=optimize $file -o optimised/$(basename "$file") --thinlto-index=index.bc &
done
wait

# echo "Optimizing"
# /Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=optimize imported/* --thinlto-index=index.bc
# mv imported/*thinlto* optimised/
# for file in optimised/*; do mv "${file}" "${file//\.thinlto.optimised.bc/}"; done

