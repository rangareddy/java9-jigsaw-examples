. ../env.sh

mkdir -p mods
mkdir -p mlib
mkdir -p classes
mkdir -p cplib 

echo "javac -Xlint -d mods --module-path mlib --module-source-path src \$(find src -name \"*.java\"| grep -v cp)"
$JAVA_HOME/bin/javac -Xlint -d mods --module-path mlib --module-source-path src $(find src -name "*.java"| grep -v cp)

pushd mods > /dev/null 2>&1
for dir in */; 
do
    MODDIR=${dir%*/}
    echo "jar --create --file=../mlib/${MODDIR}.jar -C ${MODDIR} ."
    $JAVA_HOME/bin/jar --create --file=../mlib/${MODDIR}.jar -C ${MODDIR} .
done
popd >/dev/null 2>&1



