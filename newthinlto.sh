#!/bin/bash/
alias myclang="/usr/local/google/home/nikitanazarov/Projects/llvm-project/build/bin/clang++"

function log {
	local cyan='\033[0;36m'
	local reset='\033[0m' 
	echo -e "${cyan}$1${reset}"
}

DIRS=("indices" "optimised")
for dir in ${DIRS[@]}
do
	mkdir -p $dir
	rm -f $dir/*
done

rm -f xtmp/*
sh runxtmp.sh

sh generate-summaries.sh

log "CREATING INDICES"
myclang -save-temps -flto=thin -fuse-ld=/usr/local/google/home/nikitanazarov/Projects/llvm-project/build/bin/ld.lld -Wl,-plugin-opt,thinlto-index-only summaries/* 

##for file in summaries/*; do mv "$file" "${file%.bc}.o"; done
mv *.thinlto* indices/
rm summaries/*
cp *.o summaries/ # moving *bitcode* files

##myclang -flto=thin -Wl,-plugin-opt,thinlto-index-only -Wl,-plugin-opt,thinlto-prefix-replace="summaries;indices"
##ld.lld -flto=thin -plugin-opt thinlto-index-only -plugin-opt thinlto-prefix-replace="summaries;indices" summaries/*

log "OPTIMISING"
for file in summaries/*
do
	echo "Optimising $file"
    name=$(basename "$file")
	myclang -fthinlto-index=indices/$name.thinlto.bc -x ir $file -o indices/$name -O2 -c 
done

##rm indices/*.thinlto.*
	
log "RUNNING CLANG"
myclang -fuse-ld=/usr/local/google/home/nikitanazarov/Projects/llvm-project/build/bin/ld.lld indices/*.o -o a.out

