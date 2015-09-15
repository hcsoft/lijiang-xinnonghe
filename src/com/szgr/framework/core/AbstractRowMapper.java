package com.szgr.framework.core;

import java.lang.reflect.Method;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.szgr.framework.bean.DefaultConverterImp;


@SuppressWarnings("unchecked")
public abstract class AbstractRowMapper extends DefaultConverterImp implements RowMapper {
	private final Class voClass;
	protected AbstractRowMapper(Class voClass) {
		this.voClass = voClass;
	}
	
	public Class getVoClass() {
		return this.voClass;
	}

	protected abstract Method getWriteMethod(String colName);

	public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
		int colCount = rs.getMetaData().getColumnCount();
		try {
			Object newInstance = this.voClass.newInstance();
			for (int i = 1; i <= colCount; i++) {
				
				String colName = rs.getMetaData().getColumnLabel(i);
				//rs.getMetaData().getColumnName(i);
				
				Method m = getWriteMethod(colName);
				if (m != null) {
					Object value = rs.getObject(i);
					Class[] paramTypes = m.getParameterTypes();
					if (paramTypes != null && paramTypes.length == 1) {
						Class paramType = paramTypes[0];
						Object newValue = getConvertable(paramType).convert(
								value, paramType);
						try{
						   m.invoke(newInstance, new Object[] { newValue });
						}catch(Exception ex){
							ex.printStackTrace();
							throw new ApplicationException("把结果集转换成对象出错！",ex);
						}
					}

				}
			}
			return newInstance;
		} catch (Exception e) {
			throw new ApplicationException("DefaultRowMapper map row exception"
					+ e.getMessage(), e);
		}
	}

}
