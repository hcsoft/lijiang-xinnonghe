package com.szgr.util;
public class StringUtils {
	
	public static final String EMPTY = "";
	public static final String SPLIT_STR = ",";
	
    private StringUtils(){}
    public static boolean notEmpty(String str){
    	if (str == null ||  "".equals(str.trim())) {
			return false;
		}
		return true;
    }
    public static boolean empty(String str){
    	return !notEmpty(str);
    }
    
    public static boolean nullSafeEqual(Object o1,Object o2){
    	if(o1 == null || o2 == null)
    		return false;
    	return o1.equals(o2);
    }
    public static int[] convertStringToInt(String str,String split){
    	if(str == null)
    		return null;
    	String[] strs = str.split(split);
    	int[] result = new int[strs.length];
    	for(int i = 0;i < strs.length;i++){
    		result[i] = Integer.parseInt(strs[i]);
    	}
    	return result;
    }
    public static String getSafeString(String str){
    	return str == null ? "" : str;
    }
}
