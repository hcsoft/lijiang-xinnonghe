
package com.szgr.framework.bean;

import org.springframework.core.NestedRuntimeException;


public class ConvertException extends NestedRuntimeException {

	private static final long serialVersionUID = -4325027471520584768L;
	public ConvertException(String msg){
    	super(msg);
    }
    public ConvertException(String msg,Throwable cause){
    	super(msg,cause);
    }
}
