package com.szgr.framework.core;

public class ApplicationException extends RuntimeException{

	private static final long serialVersionUID = 6315622032273877476L;

	public ApplicationException() {
		super();
	}

	public ApplicationException(String message) {
		super(message);
	}

	public ApplicationException(String message, Throwable cause) {
		super(message, cause);
	}

	public ApplicationException(Throwable cause) {
		super(cause);
	}
}
