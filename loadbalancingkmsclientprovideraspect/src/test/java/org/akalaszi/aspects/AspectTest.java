package org.akalaszi.aspects;

import java.io.IOException;
import java.security.GeneralSecurityException;

import org.apache.hadoop.crypto.key.kms.LoadBalancingKMSClientProvider;
import org.junit.Test;

/**
 * Test environment for debug aspect for HADOOP-13132
 */
public class AspectTest {

	@Test(expected=ClassCastException.class)
	public void testHADOOP13132DebugAspect() throws IOException, GeneralSecurityException {
		new LoadBalancingKMSClientProvider().decryptEncryptedKey();
	}
}
