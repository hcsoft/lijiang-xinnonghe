package com.szgr.framework.pagination;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.Type;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;

import com.szgr.framework.core.ApplicationContextUtils;
import com.szgr.framework.core.DefaultRowMapper;




/**
 * 
 */
public class PageUtil {

	public static final String PAGE_ROW = "rows";
	
	public static final String PAGE_TOTAL = "total";
	// private Page _page;

	// private Integer pageSize = 15;

	// private Integer currentpage;

	// private int firstRow;

	// private int endRow;

	private static String countJdbcSql(String sql){
		return "select count(1) from ( "+sql+") a ";
	}
	public static Page paginateCustomNativeSql(String sql,String orderBy,Object[] args,int firstRow,
			int endRow, int pageSize, int currentpage, Class resultClass,JdbcTemplate jdbcTemplate) {
		Page _page = new Page();
		
		String countSql = countJdbcSql(sql);
		int itemNum = jdbcTemplate.queryForInt(countSql, args);

		_page.setItemnum(itemNum);
		_page.setPagesize(pageSize);
		_page.setCurrentpage(currentpage);
		String nativeSql = constructNativeSql(sql, orderBy,firstRow, pageSize);
		List list = jdbcTemplate.query(nativeSql, args, new DefaultRowMapper(resultClass)); 

		if (list == null) {
			return null;
		}
		JSONArray result = new JSONArray();
		result.addAll(list);
		return _page.setResults(result);
	}
	
	public static JSONObject paginateCustomNativeSqlJson(String sql,String orderBy,Object[] args,
			int firstPage, int pageSize, Class resultClass,JdbcTemplate jt) {
		int currentpage = firstPage;
		int endRow;
		int firstRow;
		if (firstPage == 1) {
			firstRow = 0;
			endRow = pageSize;
		} else {
			firstRow = (firstPage - 1) * pageSize;
			endRow = firstRow + pageSize;
		}
		Page page = paginateCustomNativeSql(sql, orderBy,args,firstRow, endRow, pageSize,
				currentpage, resultClass,jt);

		Map<String, Object> jsonMap = new HashMap<String, Object>();// ����map
		jsonMap.put(PAGE_TOTAL, page.getItemnum());// total�� ����ܼ�¼������
		jsonMap.put(PAGE_ROW, page.getResults());// rows�� ���ÿҳ��¼ list
		JSONObject jSONObject = new JSONObject();
		jSONObject.putAll(jsonMap);
		return jSONObject;
	}
	
	public static JSONObject paginateCustomNativeSqlJson(String sql,
			int firstPage, int pageSize, Class resultClass, Session session,
			Map<String, Object> attrMap) {
		return paginateCustomNativeSqlJson(sql,null,firstPage,pageSize,resultClass,session,attrMap);
	}
	public static JSONObject paginateCustomNativeSqlJson(String sql,Object[] args,
			int firstPage, int pageSize, Class resultClass, Session session,
			Map<String, Object> attrMap) {
		int currentpage = firstPage;
		int endRow;
		int firstRow;
		if (firstPage == 1) {
			firstRow = 0;
			endRow = pageSize;
		} else {
			firstRow = (firstPage - 1) * pageSize;
			endRow = firstRow + pageSize;
		}
		Page page = paginateCustomNativeSql(sql, args,firstRow, endRow, pageSize,
				currentpage, resultClass, session, attrMap);

		Map<String, Object> jsonMap = new HashMap<String, Object>();// ����map
		jsonMap.put(PAGE_TOTAL, page.getItemnum());// total�� ����ܼ�¼������
		jsonMap.put(PAGE_ROW, page.getResults());// rows�� ���ÿҳ��¼ list
		JSONObject jSONObject = new JSONObject();
		jSONObject.putAll(jsonMap);
		return jSONObject;
	}
	
	public static JSONObject paginateCustomNativeSqlJson(String sql,Object[] args,
			int firstPage, int pageSize, Session session,List<Columns> columnslist,
			Map<String, Object> attrMap) {
		int currentpage = firstPage;
		int endRow;
		int firstRow;
		if (firstPage == 1) {
			firstRow = 0;
			endRow = pageSize;
		} else {
			firstRow = (firstPage - 1) * pageSize;
			endRow = firstRow + pageSize;
		}
		Page page = paginateCustomNativeSql(sql, args,firstRow, endRow, pageSize,
				currentpage,columnslist, session, attrMap);

		Map<String, Object> jsonMap = new HashMap<String, Object>();// ����map
		jsonMap.put(PAGE_TOTAL, page.getItemnum());// total�� ����ܼ�¼������
		jsonMap.put(PAGE_ROW, page.getResults());// rows�� ���ÿҳ��¼ list
//		JSONArray columns = new JSONArray();//��̬��
//		for (int i = 0; i < columnslist.size(); i++) {
//			columns.add(columnslist.get(i));
//		}
//		jsonMap.put("columns", columns);
//		if(page.getItemnum()==0)
//			return null;
		JSONObject jSONObject = new JSONObject();
		jSONObject.putAll(jsonMap);
		return jSONObject;
	}
	
	/**
	 * @return �����ж��巵���������
	 */
	public static Page paginateCustomNativeSql(String sql,Object[] args, int firstRow,
			int endRow, int pageSize, int currentpage, List<Columns> columnslist,
			Session session, Map<String, Object> attrMap) {
		Page _page = new Page();
		String countSql = countSql(sql);
		SQLQuery countQuery = session.createSQLQuery(countSql);
		if(args != null){
			for(int i = 0;i < args.length;i++){
				countQuery.setParameter(i, args[i]);
			}
		}
		List<Object> count = countQuery.list();
		int itemNum = (count != null && count.size()>0) ? (Integer)count.get(0):0;
		_page.setItemnum(itemNum);
		_page.setPagesize(pageSize);
		_page.setCurrentpage(currentpage);
		String nativeSql = constructNativeSql(sql, firstRow, endRow, attrMap);
		SQLQuery sqlQuery = session.createSQLQuery(nativeSql);
		if(args != null){
			for(int i = 0;i < args.length;i++){
				sqlQuery.setParameter(i, args[i]);
			}
		}
		
		for (Iterator iterator = attrMap.entrySet().iterator(); iterator
				.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			String attrName = (String) entry.getKey();
			Type attrType = (Type) entry.getValue();
			attrName = editString(attrName);
			sqlQuery.addScalar(attrName, attrType);
		}
		List<Object> list = sqlQuery.list();
		String[] attributeNames = attrMap.keySet().toArray(
				new String[0]);
		if (list == null) {
			return null;
		}
		JSONArray result = new JSONArray();
		for (int i = 0; i < list.size(); i++) {
			Object[] objects=(Object[])list.get(i);
			JSONArray tempArray=new JSONArray();
			Map<String, Object> temp = new HashMap<String, Object>();
			for (int j = 0; j < columnslist.size(); j++) {
				if(attrMap.get(columnslist.get(j).getField())==Hibernate.DATE || attrMap.get(columnslist.get(j).getField())==Hibernate.TIMESTAMP)
					temp.put(columnslist.get(j).getField(), null==objects[j]?"":objects[j].toString().substring(0, 10));
				else
					temp.put(columnslist.get(j).getField(), null==objects[j]?"":objects[j].toString());
			}
			result.add(temp);
		}
		
		return _page.setResults(result);
	}
	
//	public static JSONObject getJsonObject(List list){
//		
//	}

	// public static Page paginateCustomNativeSqlFOrGot(String sql, int
	// firstPage,
	// int pageSize, Class resultClass, Session session,
	// Map<String, Object> attrMap) {
	// int currentpage = firstPage;
	// int endRow;
	// int firstRow;
	// if (firstPage == 1) {
	// firstRow = 0;
	// endRow = pageSize;
	// } else {
	// firstRow = (firstPage - 1) * pageSize;
	// endRow = firstRow + pageSize;
	// }
	// return paginateCustomNativeSql(sql, firstRow, endRow, pageSize,
	// currentpage, resultClass, session, attrMap);
	// }
	public static Page paginateCustomNativeSql(String sql,Object[] args, int firstRow,
			int endRow, int pageSize, int currentpage, Class resultClass,
			Session session, Map<String, Object> attrMap) {
		Page _page = new Page();
		String countSql = countSql(sql);
		SQLQuery countQuery = session.createSQLQuery(countSql);
		if(args != null){
			for(int i = 0;i < args.length;i++){
				countQuery.setParameter(i, args[i]);
			}
		}
		List<Object> count = countQuery.list();
		int itemNum = (count != null && count.size()>0) ? (Integer)count.get(0):0;
		_page.setItemnum(itemNum);
		_page.setPagesize(pageSize);
		_page.setCurrentpage(currentpage);
		String nativeSql = constructNativeSql(sql, firstRow, pageSize, attrMap);
		SQLQuery sqlQuery = session.createSQLQuery(nativeSql);
		if(args != null){
			for(int i = 0;i < args.length;i++){
				sqlQuery.setParameter(i, args[i]);
			}
		}
		
		for (Iterator iterator = attrMap.entrySet().iterator(); iterator
				.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			String attrName = (String) entry.getKey();
			Type attrType = (Type) entry.getValue();
			attrName = editString(attrName);
			sqlQuery.addScalar(attrName, attrType);
		}
		List<Object> list = sqlQuery.list();
		String[] attributeNames = attrMap.keySet().toArray(
				new String[0]);
		if (list == null) {
			return null;
		}
		Object bean;
		JSONArray result = new JSONArray();
		for (int i = 0; i < list.size(); i++) {
			try {
				bean = resultClass.newInstance();
				if (attributeNames.length == 1) {
					Object row = list.get(i);
					PropertyUtils.setProperty(bean, attributeNames[0], row);
				} else {
					Object[] row = (Object[]) list.get(i);
					for (int j = 0; j < row.length; j++) {
						if (row[j] != null) {
							PropertyUtils.setProperty(bean, attributeNames[j],
									row[j]);
						}
					}
				}
				result.add(bean);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return _page.setResults(result);
	}
	public static Page paginateCustomNativeSql(String sql, int firstRow,
			int endRow, int pageSize, int currentpage, Class resultClass,
			Session session, Map<String, Object> attrMap) {
		return paginateCustomNativeSql(sql,null,firstRow,endRow,pageSize,currentpage,resultClass,session,attrMap);
	}
	
	private static String countSql(String sql) {
		StringBuilder str = new StringBuilder(" select count(*) ");
		String tempSql = sql;
		if (tempSql.indexOf(" group by ") > 0) {
			String xSql = tempSql.substring(tempSql.lastIndexOf(" group by "));
			if(xSql.indexOf(")") <= 0){
				tempSql = tempSql.substring(0, tempSql.lastIndexOf(" group by "));
			}			
		}
		if (tempSql.indexOf(" order by ") > 0) {
			String xSql = tempSql.substring(tempSql.lastIndexOf(" order by "));
			if(xSql.indexOf(")") <= 0){
				tempSql = tempSql.substring(0, tempSql.lastIndexOf(" order by "));
			}			
		}
		str.append(tempSql.substring(tempSql.indexOf(" from ") + 1));
		return str.toString();
	}
    
//	private static String constructNativeSql(String sql,String orderBy, int firstRow,
//			int endRow) {
//		String nativeSql = sql;
//		String orderSql = orderBy != null ? orderBy : "";
//		// ��order by ����һ��
//		if (nativeSql.indexOf(" order by ") > 0) {
//			orderSql = nativeSql
//					.substring(nativeSql.lastIndexOf(" order by ") + 1);
//			nativeSql = nativeSql.substring(0, nativeSql
//					.lastIndexOf(" order by ") + 1);
//		}
//		// ƴ��ʱ���ҳsql
//		nativeSql = nativeSql.replaceFirst("select", "select top " + endRow
//				+ " rowid=identity(10),");
//		nativeSql = nativeSql.replaceFirst(" from ",
//				" into #pageutiltmp1 from ");
//
//		String pageSql = "select * from #pageutiltmp1 _ba where _ba.rowid>" + firstRow
//				+ " and _ba.rowid<=" + endRow;
//		nativeSql += orderSql + " " + pageSql + " drop table #pageutiltmp1";
//		return nativeSql;
//	}
	private static String constructNativeSql(String sql,String orderBy, int firstRow,
			int pageSize) {
		String nativeSql = sql;
		String orderSql = orderBy != null ? orderBy : "";
		// ��order by ����һ��
		if (nativeSql.indexOf(" order by ") > 0) {
			orderSql = nativeSql
					.substring(nativeSql.lastIndexOf(" order by ") + 1);
			nativeSql = nativeSql.substring(0, nativeSql
					.lastIndexOf(" order by ") + 1);
		}
		nativeSql = nativeSql.replaceFirst("select" ,"select top "+pageSize+" from (select ROW_NUMBER() over ("+orderSql+") as RowNumber,");
		// ƴ��ʱ���ҳsql
//		nativeSql = nativeSql.replaceFirst("select", "select top " + endRow
//				+ " rowid=identity(10),");
		nativeSql = nativeSql + ") a where RowNumber  >"+firstRow;
//		nativeSql = nativeSql.replaceFirst(" from ",
//				" into #pageutiltmp1 from ");
//
//		String pageSql = "select * from #pageutiltmp1 _ba where _ba.rowid>" + firstRow
//				+ " and _ba.rowid<=" + endRow;
//		nativeSql += orderSql + " " + pageSql + " drop table #pageutiltmp1";
		return nativeSql;
	}
	
	private static String constructNativeSql(String sql, int firstRow,
			int pageSize, Map<String, Object> attrMap) {
		String nativeSql = sql;
		String orderSql = "";
		// ��order by ����һ��
		if (nativeSql.indexOf(" order by ") > 0) {
			orderSql = nativeSql
					.substring(nativeSql.lastIndexOf(" order by ") + 1);
			nativeSql = nativeSql.substring(0, nativeSql
					.lastIndexOf(" order by ") + 1);
		}
		nativeSql = nativeSql.replaceFirst("select" ,"select top "+pageSize+" * from (select ROW_NUMBER() over ("+orderSql+") as RowNumber,");
		// ƴ��ʱ���ҳsql
//		nativeSql = nativeSql.replaceFirst("select", "select top " + endRow
//				+ " rowid=identity(10),");
		nativeSql = nativeSql + ") a where RowNumber  >"+firstRow;
//		nativeSql = nativeSql.replaceFirst(" from ",
//				" into #pageutiltmp1 from ");
//
//		String pageSql = "select * from #pageutiltmp1 _ba where _ba.rowid>" + firstRow
//				+ " and _ba.rowid<=" + endRow;
//		nativeSql += orderSql + " " + pageSql + " drop table #pageutiltmp1";
		return nativeSql;
	}

	/**
	 * ȥ��",."��֮�䣬����"."������
	 * 
	 * @param str
	 * @return
	 */
	private static String editString(String str) {
		if (str.indexOf(".") == -1) {
			return str;
		}
		return str.concat(" ").replaceAll("[a-zA-Z0-9]+\\.([a-zA-Z0-9]+[, $])",
				"$1").trim();
	}
	
	public static <T> List<T>  getListVo(String querySql,Object[] args,Class<T> cls){
		return ApplicationContextUtils.getJdbcTemplate().query(querySql, args, new DefaultRowMapper(cls));
	}
	
}