#!/bin/bash/
alias myclang="/Users/nikitanazarov/Projects/llvm-project/build/bin/clang++"

DIRS=("indices" "optimised")
for dir in ${DIRS[@]}
do
	mkdir -p $dir
	rm -f $dir/*
done

sh summaries.sh

echo "Creating indices"
myclang -flto=thin -fuse-ld=lld -Wl,-plugin-opt,thinlto-index-only -Wl,-plugin-opt,thinlto-prefix-replace="summaries;indices" summaries/*
#myclang -flto=thin -Wl,-plugin-opt,thinlto-index-only -Wl,-plugin-opt,thinlto-prefix-replace="summaries;indices"
#ld.lld -flto=thin -plugin-opt thinlto-index-only -plugin-opt thinlto-prefix-replace="summaries;indices" summaries/*

for file in summaries/*
do
	echo "Optimising $file"
	name=$(basename "$file")
	myclang -fthinlto-index=indices/$name.thinlto.bc -x ir $file -o indices/$name -O2 -c &
done
wait
