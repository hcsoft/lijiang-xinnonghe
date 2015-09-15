
package com.szgr.framework.bean.converter;

import com.szgr.framework.bean.ConvertException;
import com.szgr.framework.bean.TypeConverter;

public class StringConverter implements TypeConverter {
	
	public Object convert(Object value, Class<?> requiredType)
			throws ConvertException {
		if(requiredType.equals(String.class) && value != null)
			return value.toString();
		return value;
	}
    
}
