
package com.szgr.framework.bean.converter;

import com.szgr.framework.bean.ConvertException;
import com.szgr.framework.bean.TypeConverter;



/**
 * 
* <p>Title: DefaultConverter.java</p>
* <p>Description: Ä¬ÈÏµÄConverter</p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-6-6
* @version 1.0
 */
public class DefaultConverter implements TypeConverter {
	public Object convert(Object value, Class<?> requiredType)
			throws ConvertException {
		return value;
	}
}
