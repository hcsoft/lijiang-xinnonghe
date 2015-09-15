package com.szgr.framework.bean;


public interface TypeConverter {
    public Object convert(Object value,Class<?> requiredType) throws ConvertException;
}
