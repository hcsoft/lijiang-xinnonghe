package com.szgr.framework.interfaces;

/**
 * ��������ӿ�
 *
 * @param <ReqBean> ����Bean
 * @param <RetBean> ����Bean
 */
public interface IService<ReqBean, RetBean> {
	/**
	 * ���ʷ���
	 * @param url �����ַ
	 * @param t �������
	 * @return ������
	 * @throws Exception
	 */
	public RetBean access(String url, ReqBean t) throws Exception;
}
