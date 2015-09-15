package com.szgr.framework.bean.converter;

import com.szgr.framework.bean.ConvertException;
import com.szgr.framework.bean.TypeConverter;

public class IntegerConverter implements TypeConverter {
	
	public Object convert(Object value, Class<?> requiredType)
			throws ConvertException {
		if(value == null)
			return null;
		if(value != null && value.getClass() == requiredType){
			return value;
		}else
		   return Integer.valueOf(value.toString());
	}
    
}

