package com.szgr.framework.core;

public class ValidDataException extends ApplicationException{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3502123234760424495L;

	public ValidDataException() {
		super();
	}

	public ValidDataException(String message) {
		super(message);
	}

	public ValidDataException(String message, Throwable cause) {
		super(message, cause);
	}

	public ValidDataException(Throwable cause) {
		super(cause);
	}
}
