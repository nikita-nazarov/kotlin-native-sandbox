#!bin/bash/

rm summaries/*thinlto*
rm llvm-lto-tmp/*
rm optimised1/*
/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=run summaries/*
mv summaries/*thinlto* optimised1/
for file in optimised1/*; do mv "${file}" "${file//\.thinlto.o/}"; done
