package com.szgr.common.excel;

import com.szgr.framework.core.ApplicationException;

public class ExcelException extends ApplicationException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3555502971820173138L;

	public ExcelException() {
		super();
	}

	public ExcelException(String message) {
		super(message);
	}

	public ExcelException(String message, Throwable cause) {
		super(message, cause);
	}

	public ExcelException(Throwable cause) {
		super(cause);
	}
}
