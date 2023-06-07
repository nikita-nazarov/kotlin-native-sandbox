#!bin/bash/

sh generate-summaries.sh

echo "Running Thin LTO"

/usr/local/google/home/nikitanazarov/Projects/llvm-project/build/bin/clang++ -flto=thin -fuse-ld=/usr/local/google/home/nikitanazarov/Projects/llvm-project/build/bin/ld.lld summaries/* -o a.out
