package com.szgr.framework.interfaces.stringbased.json;

import org.codehaus.jackson.map.ObjectMapper;

import com.szgr.framework.interfaces.stringbased.IStringSerilizer;


/**
 * json���л������л���
 *
 */
public class JsonSerilizer implements IStringSerilizer{
	public String serialise(Object bean) throws Exception {
		ObjectMapper mapper = new ObjectMapper(); 
		String json = mapper.writeValueAsString(bean);
		return json;
	}

	public Object doSerialise(String json, Class clazz) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		Object ret = mapper.readValue(json, clazz); 
		return ret;
	}
}
