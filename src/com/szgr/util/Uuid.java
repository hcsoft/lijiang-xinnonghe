package com.szgr.util;

import java.util.UUID;

public class Uuid {
    public static String newUuid(){
    	return UUID.randomUUID().toString().replace("-","");
    }
}
