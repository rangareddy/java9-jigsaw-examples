. ../env.sh

mkdir -p mods
mkdir -p mlib
 
# compile modc
echo "javac -d mods --module-path mlib --module-source-path src \$(find src/modc -name \"*.java\")"
$JAVA_HOME/bin/javac -d mods \
    --module-path mlib --module-source-path src $(find src/modc -name "*.java")
      
# compile modb (add-read from modb -> modc)
echo "javac -d mods --module-path mlib --add-reads modb=modc --add-exports modc/pkgc=modb --module-source-path src \$(find src/modb -name \"*.java\")"
$JAVA_HOME/bin/javac -d mods \
    --add-reads modb=modc \
    --add-exports modc/pkgc=modb \
    --add-modules modc \
    --module-path mlib \
    --module-source-path src $(find src/modb -name "*.java")

# compile modmain: (add-read from modb -> modc , and add-export of modb/pkgb -> modmain)
echo "javac -d mods --add-reads modb=modc --add-exports modb/pkgb=modmain --add-exports modc/pkgc=modb --module-path mlib --module-source-path src \$(find src/modmain -name \"*.java\")"
$JAVA_HOME/bin/javac -d mods \
    --add-reads modb=modc \
    --add-exports modb/pkgb=modmain \
    --add-exports modc/pkgc=modb \
    --add-modules modc \
    --module-path mlib \
    --module-source-path src $(find src/modmain -name "*.java")

pushd mods > /dev/null 2>&1
for dir in */; 
do
    MODDIR=${dir%*/}
    echo "jar --create --file=../mlib/${MODDIR}.jar -C ${MODDIR} ."
    $JAVA_HOME/bin/jar --create --file=../mlib/${MODDIR}.jar -C ${MODDIR} .
done
popd >/dev/null 2>&1
