#!bin/bash/

alias my-llvm-lto="/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto"

rm summaries/*thinlto*
rm llvm-lto-tmp/*

echo "Running step by step"
my-llvm-lto --thinlto-action=thinlink summaries/bitcodeDump.bc -o index_tmp.bc
my-llvm-lto --thinlto-action=internalize summaries/bitcodeDump.bc --thinlto-index=index_tmp.bc
llvm-bcanalyzer summaries/bitcodeDump.bc.thinlto.internalized.bc > bc1.txt

echo "Running all at once"
my-llvm-lto --thinlto-action=run summaries/bitcodeDump.bc
llvm-bcanalyzer llvm-lto-tmp/0.2.internalized.bc  > bc2.txt
