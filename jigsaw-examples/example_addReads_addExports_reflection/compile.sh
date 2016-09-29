. ../env.sh

mkdir -p mods
mkdir -p mlib

# compile modb
echo "javac -d mods --module-path mlib --module-source-path src \$(find src/modb -name \"*.java\")"
$JAVA_HOME/bin/javac -d mods \
    --module-path mlib --module-source-path src $(find src/modb -name "*.java")

# compile modmain (add-export of modb/pkgb -> modmain)
echo "javac -d mods --add-exports modb/pkgb=modmain --module-path mlib -modulesourcepath src \$(find src/modmain -name \"*.java\")"
$JAVA_HOME/bin/javac -d mods \
    --add-exports modb/pkgb=modmain \
    --module-path mlib --module-source-path src $(find src/modmain -name "*.java")

pushd mods > /dev/null 2>&1
for dir in */; 
do
    MODDIR=${dir%*/}
    echo "jar --create --file=../mlib/${MODDIR}.jar -C ${MODDIR} ."
    $JAVA_HOME/bin/jar --create --file=../mlib/${MODDIR}.jar -C ${MODDIR} .
done
popd >/dev/null 2>&1
