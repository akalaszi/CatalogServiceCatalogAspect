# Debugging environment and Aspect for IMPALA-3949 

### Background
Imapala catalogd may unable to find UDF jars while the following error is logged at the service log, eg: 

```
E1007 19:38:56.543897 21758 CatalogServiceCatalog.java:508] Skipping function load: r3_add_file_v3
Java exception follows:
com.cloudera.impala.common.ImpalaRuntimeException: Error extracting functions
        at com.cloudera.impala.catalog.CatalogServiceCatalog.extractFunctions(CatalogServiceCatalog.java:462)
        at com.cloudera.impala.catalog.CatalogServiceCatalog.loadJavaFunctions(CatalogServiceCatalog.java:503)
        at com.cloudera.impala.catalog.CatalogServiceCatalog.reset(CatalogServiceCatalog.java:559)
        at com.cloudera.impala.service.JniCatalog.<init>(JniCatalog.java:100)
Caused by: com.cloudera.impala.common.ImpalaRuntimeException: Error loading Java function: lab_samp.r3_add_file_v3. Couldn't copy hdfs:///<path-to-jar-file> to local path: file:/tmp/c985556e-cdef-4356-9e72-3a4f41554b2f.jar
        at com.cloudera.impala.catalog.CatalogServiceCatalog.extractFunctions(CatalogServiceCatalog.java:424)
        ... 3 more
```

As described at https://issues.cloudera.org/browse/IMPALA-3949 the following method swallows exception, which makes debugging prod env more difficult.

```
public static boolean copyToLocal(Path source, Path dest) {
330     try {
331       FileSystem fs = source.getFileSystem(CONF);
332       fs.copyToLocalFile(source, dest);
333     } catch (IOException e) {
334       return false;
335     }
336     return true;
337   }
```

This has already been fixed in the master branch of Impala:
https://github.com/cloudera/Impala/blob/cdh5-trunk/fe/src/main/java/org/apache/impala/common/FileSystemUtil.java#L377

This project provides an aspect that prints the stacktrace of the swallowed IOException to the stderr without the need of recompiling Hadoop/Impala.

### How to Compile Test Environment
- cd testenvironment
- mvn package
- java -jar target/fileutilaspect-1.0-SNAPSHOT.jar
[this will throw the ClassCastException]

### How to Install AspectJ 
- Download latest aspectj jar: https://eclipse.org/aspectj/downloads.php
- Launch the installer jar: mkdir /some/dir/aspect;java -jar aspectj-1.8.9.jar -to /some/dir/aspect
- edit the ajc shell script: vi /some/dir/aspect/bin/add $ASPECTJ_HOME/lib/aspectjrt.jar to the classpath
- add /some/dir/aspect/bin to the PATH

### How to build & run AspectJ 
- cd CatalogServiceCatalogAspect/debugaspect/
- Copy here the two jars from AspectJ: cp /some/dir/aspect/lib/aspectjweaver.jar /some/dir/aspect/lib/aspectjrt.jar .
- run test.sh or:
- rm -f aspect.jar;ajc -cp filesystem-test-env-1.0-SNAPSHOT.jar:aspectjrt.jar -outjar aspect.jar src/aspects/*.aj;jar uf aspect.jar META-INF/
- java -javaagent:aspectjweaver.jar -classpath "aspect.jar:aspectjrt.jar:filesystem-test-env-1.0-SNAPSHOT.jar" org.akalaszi.TestEnv

### Add that to catalogd
Copy aspect.jar, aspectjrt.jar and aspectjweaver.jar to /tmp on the catalogd host, and temporarily add the followings to:
- ClouderaManager->Impala->Configuration->Java Configuration Options for Catalog Server: -javaagent:/tmp/aspectjweaver.jar
- ClouderaManager->Impala->Configuration->Impala Service Environment Advanced Configuration Snippet (Safety Valve)-> AUX_CLASSPATH="/tmp/aspect.jar:/tmp/aspectjrt.jar"

### Links
- https://eclipse.org/aspectj/doc/next/devguide/ajc-ref.html
- http://andrewclement.blogspot.hu/2009/02/load-time-weaving-basics.html

###
Tested with 
java version "1.8.0_60"
Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)
