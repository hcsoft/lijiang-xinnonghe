package com.szgr.framework.bean.converter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.szgr.framework.bean.ConvertException;
import com.szgr.framework.bean.TypeConverter;
import com.szgr.framework.core.ApplicationException;

public class DateConverter implements TypeConverter {
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	public Object convert(Object value, Class<?> requiredType)
	throws ConvertException {
		if(value == null || requiredType.equals(value.getClass())){
			return value;
		}
		String str = value.toString();
		try {
			Date date =  sdf.parse(str);
			return date;
		} catch (ParseException e) {
			throw new ApplicationException("½âÎöÈÕÆÚ´íÎó,"+str,e);
		}
}
}
