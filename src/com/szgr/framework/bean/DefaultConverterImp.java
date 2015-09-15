
package com.szgr.framework.bean;


import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.springframework.util.Assert;

import com.szgr.framework.bean.converter.DefaultConverter;
import com.szgr.framework.bean.converter.IntegerConverter;
import com.szgr.framework.bean.converter.StringConverter;





@SuppressWarnings("unchecked")
public class DefaultConverterImp implements ConvertContainer {
	
	private final Map map = Collections.synchronizedMap(new HashMap());

	public DefaultConverterImp() {
		TypeConverter stringConverter = new StringConverter();
		registerConverter(String.class, stringConverter);
		registerConverter(Integer.class,new IntegerConverter());
	}
	public TypeConverter getConvertable(Class type) {
		TypeConverter result = (TypeConverter) map.get(type);
		return result == null ? new DefaultConverter() : result;
	}

	public void registerConverter(Class type, TypeConverter convertable) {
		Assert.notNull(convertable, "Convertable converterable must not null!");
		Assert.notNull(type, "Class type must not null!");
		map.put(type, convertable);
	}

	public void removeConverter(Class type) {
		map.remove(type);
	}

}
