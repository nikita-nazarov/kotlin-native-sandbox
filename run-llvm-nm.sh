#!bin/bash/

alias llvm-nm="/usr/local/google/home/nikitanazarov/Projects/llvm-project/build/bin/llvm-nm"

dir=$1
pattern=$2
for file in $dir/*; do echo $file; llvm-nm $file | grep $pattern; done

