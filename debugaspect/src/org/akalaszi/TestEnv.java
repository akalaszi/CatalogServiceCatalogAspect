package org.akalaszi;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;

public class TestEnv {

	public static void main(String[] args) throws IOException {
		Path source = new Path();
		try {
			System.err.println("1");
			FileSystem fs = source.getFileSystem(new Configuration());
			System.err.println("2");
			fs.copyToLocalFile(source, new Path());
		} catch (IOException e) {
			System.err.println("false");
		}
	}

}
