#!bin/bash/

alias kndist="~/IdeaProjects/kotlin/kotlin-native/dist/bin/kotlinc-native"

rm -f xtmp/*
# JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005" kndist main.kt -Xtemporary-files-dir=xtmp -o a.out
kndist main.kt -Xtemporary-files-dir=xtmp -o a.out

