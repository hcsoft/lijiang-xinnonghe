package com.szgr.framework.interfaces.stringbased;


/**
 * 字符类型的序列化器，可以是json或xml等
 *
 */
public interface IStringSerilizer {
	/**
	 * 序列化
	 * @param bean
	 * @return
	 * @throws Exception
	 */
	public String serialise(Object bean) throws Exception ;

	/**
	 * 反序列化
	 * @param json
	 * @param clazz
	 * @return
	 * @throws Exception
	 */
	public Object doSerialise(String json, Class clazz) throws Exception;
}
