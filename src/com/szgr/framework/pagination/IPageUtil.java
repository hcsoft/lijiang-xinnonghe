package com.szgr.framework.pagination;

import java.util.Map;

import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateTemplate;


/**
 * ��ҳ����
 * 
 */
public interface IPageUtil {

	/**
	 * ���÷�ҳ����
	 * 
	 * @param sql
	 * @param firstPage
	 * @param endRow
	 * @param resultClass
	 * @param session
	 * @param attrMap
	 * @return
	 */
	public Page paginateCustomNativeSql(String sql, int firstPage, int endRow,
			Class resultClass, Session session, Map<String, Object> attrMap);

	/**
	 * ͨ��got��ܵ��÷���ʱ�����÷�ҳ����
	 * 
	 * @param sql
	 * @param firstRow
	 * @param pageSize
	 * @param resultClass
	 * @param session
	 * @param attrMap
	 * @return
	 */
	public Page paginateCustomNativeSqlFOrGot(String sql, int firstPage,
			int pageSize, Class resultClass,Session session,
			Map<String, Object> attrMap);
}
