package com.szgr.framework.pagination;

import java.util.Map;

import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateTemplate;


/**
 * 分页处理
 * 
 */
public interface IPageUtil {

	/**
	 * 调用分页方法
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
	 * 通过got框架调用服务时，所用分页方法
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
