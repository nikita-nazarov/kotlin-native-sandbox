#!bin/bash/

KOTLINC_DIST=/Users/nikitanazarov/IdeaProjects/kotlin/kotlin-native/dist/bin/kotlinc-native

mkdir -p experiment/
rm -f experiment/*

cp summaries/* experiment/
rm experiment/bitcodeDump.bc
cp imported/bitcodeDump.bc experiment/
$KOTLINC_DIST -Xread-framework-bitcode main.kt -Xtemporary-files-dir=experiment
