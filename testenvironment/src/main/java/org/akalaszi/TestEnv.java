package org.akalaszi;

import java.io.IOException;
import java.security.GeneralSecurityException;

import org.apache.hadoop.crypto.key.kms.LoadBalancingKMSClientProvider;

public class TestEnv {

	public static void main(String[] args) throws IOException, GeneralSecurityException {
		new LoadBalancingKMSClientProvider().decryptEncryptedKey();
	}

}
