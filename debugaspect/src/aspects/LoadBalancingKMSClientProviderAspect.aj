package aspects;

/**
 * The method org.apache.hadoop.crypto.key.kms.LoadBalancingKMSClientProvider.
 * decryptEncryptedKey cast an exception as described at
 * https://issues.apache.org/jira/browse/HADOOP-13132. This cast can be broken
 * when unexpected exception is thrown like: ava.lang.ClassCastException:
 * org.apache.hadoop.security.authentication.client.AuthenticationException
 * cannot be cast to java.security.GeneralSecurityException at
 * org.apache.hadoop.crypto.key.kms.LoadBalancingKMSClientProvider.
 * decryptEncryptedKey(LoadBalancingKMSClientProvider.java:189) This aspect
 * prints the message and the stacktrace of the swallowed exception.
 * 
 * https://eclipse.org/aspectj/doc/next/devguide/ltw.html
 *
 * -javaagent:lib/aspectjweaver.jar
 * 
 * 
 * @author akalaszi
 *
 */
public aspect LoadBalancingKMSClientProviderAspect {
	pointcut doOpPointcut() :
	 call(* org.apache.hadoop.crypto.key.kms.LoadBalancingKMSClientProvider.doOp(* , int ) ) ;

	after() throwing (Exception e): doOpPointcut() {
		System.err.println("HADOOP-13132:");
		e.printStackTrace();
	}

}

//aop.xml 
//<aspectj>
//  <weaver options="-showWeaveInfo"> 
//	  <include within="org.apache.hadoop.crypto.key.kms.LoadBalancingKMSClientProvider"/>
//  </weaver>
//</aspectj>