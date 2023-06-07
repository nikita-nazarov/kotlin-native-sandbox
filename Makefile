KOTLINC_DIST=~/IdeaProjects/kotlin/kotlin-native/dist/bin/kotlinc-native 

build:
	kotlinc-native -g main.kt -o demo # -Xdump-directory=demo.kexe.dSYM/ -Xphases-to-dump=ALL

issue:
	kotlinc-native -g issue.kt -o issue 

dist:
	$(KOTLINC_DIST)  -g issue.kt -o issue_dist

debug:
	./wait_for_debugger.sh kotlinc-native -g issue.kt -o issue 

llvm:
	kotlinc-native -g --print_bitcode -e testing.main example/example.kt 2> example/original_llvm.ir -o example	

llvm-dist:
	$(KOTLINC_DIST) -g --print_bitcode -e testing.main example/example.kt 2> example/new_llvm.ir -o example	

out:
	uAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005" $(KOTLINC_DIST) -Xtemporary-files-dir=tmp -Xproduce-framework-bitcode main.kt

in:
	$(KOTLINC_DIST) -Xread-framework-bitcode main.kt -Xtemporary-files-dir=tmp

fresh: clean out-bitcode in-bitcode

produce-summary:
	opt --thinlto-bc tmp/bitcodeDump.bc -o thinLtoProgram.bc
	# Search for GLOBALVAL_SUMMARY_BLOCK to confirm that ThinLTO summary was generated

thinlto:
	/Users/nikitanazarov/Projects/thinlto/target/debug/thinlto tmp chart/times

thin-lto:
	llvm-lto --thinlto-action=thinlink tmp/bitcodeDump.bc -o tmp/index.bc	
	llvm-lto --thinlto-action=promote tmp/bitcodeDump.bc --thinlto-index=tmp/index.bc -o tmp/bitcodeDump.bc
	llvm-lto --thinlto-action=import tmp/bitcodeDump.bc --thinlto-index=tmp/index.bc -o tmp/bitcodeDump.bc
	llvm-lto --thinlto-action=optimize tmp/bitcodeDump.bc -o tmp/bitcodeDump.bc

thinlto-in-one-invocation:
	/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=run summaries/*

thinlink:
	/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=thinlink summaries/* -o index.bc

import:
	/Users/nikitanazarov/Projects/llvm-project/build/bin/llvm-lto --thinlto-action=import internalised/* --thinlto-index=index.bc
	mv internalised/*thinlto* imported/
	for file in imported/*; do mv "$${file}" "$${file//\.thinlto.imported.bc/}"; done

full-thin-lto-pipeline: out-bitcode produce-summary thin-lto in-bitcode

default: build

clean:
	rm -f *.kexe 
	rm -rf *.kexe.dSYM/ 
	rm -f tmp/* 
	rm -f dump/*

# JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005" 
