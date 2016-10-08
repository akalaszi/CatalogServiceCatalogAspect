package org.apache.hadoop.fs;

import java.io.IOException;

public class Path {
	public org.apache.hadoop.fs.FileSystem getFileSystem(org.apache.hadoop.conf.Configuration conf) throws IOException {
		//throw new IOException("getFileSystem");
		System.err.println("3");
		return new FileSystem();
	}
}
