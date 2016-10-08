set -e -x
testfile=filesystem-test-env-1.0-SNAPSHOT.jar
dot=`pwd`
cd ../testenvironment
mvn clean package
cp target/$testfile $dot
cd $dot
rm -f aspect.jar
ajc -cp $testfile:aspectjrt.jar -outjar aspect.jar src/aspects/*.aj
jar uf aspect.jar META-INF/;java -javaagent:aspectjweaver.jar -classpath "aspect.jar:aspectjrt.jar:$testfile" com.cloudera.impala.common.FileSystemUtil
