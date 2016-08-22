#Debugging environment and Aspect for HADOOP-13132

###Background
As per https://issues.apache.org/jira/browse/HADOOP-13132 ClassCastException
can be thrown at LoadBalancingKMSClientProvider.decryptEncryptedKey which
hides the information from the underlying AuthenticationException. This This
aspect prints the stacktrace and the message of the AuthenticationException
to the stderr before the ClassCastException is thrown.

```
java.lang.ClassCastException: 
org.apache.hadoop.security.authentication.client.AuthenticationException 
cannot be cast to java.security.GeneralSecurityException at org.apache.hadoop.crypto.key.kms.LoadBalancingKMSClientProvider.
decryptEncryptedKey(LoadBalancingKMSClientProvider.java:189) 
```

###How to Compile Test Environment
- cd testenvironment
- mvn package
- java -jar target/loadbalancingkmsclientprovideraspect-1.0-SNAPSHOT.jar 
[this will throw the ClassCastException]


###How to Install AspectJ 
- Download latest aspectj jar: https://eclipse.org/aspectj/downloads.php
- Launch the installer jar: mkdir /some/dir/aspect;java -jar aspectj-1.8.9.jar -to /some/dir/aspect
- edit the ajc shell script: vi /some/dir/aspect/bin/add $ASPECTJ_HOME/lib/aspectjrt.jar to the classpath
- add /some/dir/aspect/bin to the PATH

###How to build & run AspectJ 
- cd LoadBalancingKMSClientProviderAspect/debugaspect/
- rm -f aspect.jar;ajc -outjar aspect.jar src/aspects/LoadBalancingKMSClientProviderDebug.aj;jar uf aspect.jar META-INF/*
- cp /some/dir/aspect/lib/aspectjweaver.jar /some/dir/aspect/lib/aspectjrt.jar .
- java -javaagent:aspectjweaver.jar -classpath "aspect.jar:aspectjrt.jar:loadbalancingkmsclientprovideraspect-1.0-SNAPSHOT.jar" org.akalaszi.TestEnv

###Links
- https://eclipse.org/aspectj/doc/next/devguide/ajc-ref.html
- http://andrewclement.blogspot.hu/2009/02/load-time-weaving-basics.html




