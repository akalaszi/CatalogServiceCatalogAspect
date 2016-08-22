package aspects;

/**
 * As per https://issues.apache.org/jira/browse/HADOOP-13132 ClassCastException
 * can be thrown at LoadBalancingKMSClientProvider.decryptEncryptedKey which
 * hides the information from the underlying AuthenticationException. This This
 * aspect prints the stacktrace and the message of the AuthenticationException
 * to the stderr before the ClassCastException is thrown.
 */
public aspect LoadBalancingKMSClientProviderDebug {
	pointcut doOpPointcut() :
	 call(* *.LoadBalancingKMSClientProvider.doOp(* , int ) ) ;

	after() throwing (Exception e): doOpPointcut() {
		System.err.println("HADOOP-13132:");
		e.printStackTrace();
	}

}