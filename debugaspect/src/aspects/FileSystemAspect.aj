package aspects;

public aspect FileSystemAspect {

	pointcut getFileSystemPointcut() :
		 call(org.apache.hadoop.fs.FileSystem org.apache.hadoop.fs.Path.getFileSystem(*) ) ;

	after() throwing (Exception e): getFileSystemPointcut() {
		System.err.println("IMPALA-3949: getFileSystem: ");
		e.printStackTrace();
	}

	after() returning() : getFileSystemPointcut() {
		System.err.println("getFileSystem returned");
	}

	pointcut copyToLocalFilePointcut() :
			 call(void org.apache.hadoop.fs.FileSystem.copyToLocalFile(*, *) ) ;

	after() throwing (Exception e): copyToLocalFilePointcut() {
		System.err.println("IMPALA-3949: copyToLocalFile: ");
		e.printStackTrace();
	}

	after() returning() : copyToLocalFilePointcut() {
		System.err.println("copyToLocalFile returned");
	}
}
