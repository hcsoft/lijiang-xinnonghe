package com.szgr.common.sp;


public class SpException extends Exception {
    public SpException() {
        super();
    }

    public SpException(String message) {
        super(message);
    }

    public SpException(Throwable cause) {
        super(cause);
    }

    public SpException(String message, Throwable cause) {
        super(message, cause);
    }

}
