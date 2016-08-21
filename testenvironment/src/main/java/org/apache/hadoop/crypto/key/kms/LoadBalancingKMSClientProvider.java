package org.apache.hadoop.crypto.key.kms;

import java.io.IOException;
import java.security.GeneralSecurityException;

import org.apache.hadoop.security.authentication.client.AuthenticationException;

public class LoadBalancingKMSClientProvider {
	static interface ProviderCallable<T> {
		// public T call(KMSClientProvider provider) throws IOException,
		// Exception;
	}

	@SuppressWarnings("serial")
	static class WrapperException extends RuntimeException {
		public WrapperException(Throwable cause) {
			super(cause);
		}
	}

	public String decryptEncryptedKey() throws IOException, GeneralSecurityException {
		try {
			return doOp(new ProviderCallable<String>() {
			}, 0);
		} catch (WrapperException we) {
			throw (GeneralSecurityException) we.getCause();
		}
	}

	private <T> T doOp(ProviderCallable<T> op, int currPos) throws IOException {
		throw new WrapperException(new AuthenticationException("test"));
	}
	
}
