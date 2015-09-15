
package com.szgr.framework.bean;

public interface ConvertContainer {

	public void registerConverter(Class<?> type,TypeConverter convertable);

    public void removeConverter(Class<?> type);

    public TypeConverter getConvertable(Class<?> type);
}
