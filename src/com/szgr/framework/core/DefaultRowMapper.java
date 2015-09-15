package com.szgr.framework.core;

import java.beans.PropertyDescriptor;

import java.lang.reflect.Method;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;

import org.springframework.jdbc.core.RowMapper;


@SuppressWarnings("unchecked")
public class DefaultRowMapper extends AbstractRowMapper implements RowMapper {
	
	private Map<String,Method> cachMethod;

	public DefaultRowMapper(Class voClass) {
		super(voClass);
		this.cachMethod = new HashMap<String,Method>();
		initialMethodInfo();
	}
    
	private void initialMethodInfo() {
		try {

			PropertyDescriptor[] pds = PropertyUtils
					.getPropertyDescriptors(this.getVoClass());
			for (int i = 0; i < pds.length; i++) {
				PropertyDescriptor pd = pds[i];
				Method writeMethod = pd.getWriteMethod();
				if (writeMethod == null)
					continue;
				this.cachMethod.put(pd.getName().toLowerCase(), writeMethod);
			}
		} finally {
			PropertyUtils.clearDescriptors();
		}
	}

	
	protected Method getWriteMethod(String colName) {
		return this.cachMethod.get(colName.toLowerCase());
	}
}
