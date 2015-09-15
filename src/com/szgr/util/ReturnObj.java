package com.szgr.util;

public class ReturnObj<T> {
	
	
    private boolean sucess;
    
    private T result;
    
    private String message;

    public ReturnObj(){}
    public ReturnObj(boolean sucess,T result,String message){
    	this.sucess = sucess;
    	this.result = result;
    	this.message = message;
    }
	public boolean isSucess() {
		return sucess;
	}

	public void setSucess(boolean sucess) {
		this.sucess = sucess;
	}

	public T getResult() {
		return result;
	}

	public void setResult(T result) {
		this.result = result;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
