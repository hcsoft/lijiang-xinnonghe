package com.szgr.framework.interfaces.stringbased;


/**
 * �ַ����͵����л�����������json��xml��
 *
 */
public interface IStringSerilizer {
	/**
	 * ���л�
	 * @param bean
	 * @return
	 * @throws Exception
	 */
	public String serialise(Object bean) throws Exception ;

	/**
	 * �����л�
	 * @param json
	 * @param clazz
	 * @return
	 * @throws Exception
	 */
	public Object doSerialise(String json, Class clazz) throws Exception;
}
