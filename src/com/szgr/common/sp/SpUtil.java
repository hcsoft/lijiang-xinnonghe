package com.szgr.common.sp;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.log4j.Logger;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.Type;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Store procedure util
 */

public class SpUtil {
  private static Logger log = Logger.getLogger(SpUtil.class);

  /**
   * ���ô洢���̣����ؽ����
   * �洢���� ��Ҫ�����ݿ���ִ�У�sp_procxmode sp_myproc, "anymode"
   *
   * @param spSql       �洢���̵�sql, example: { call testsp(?,?) }
   * @param session     hibernate��session
   * @param resultClass ����List����а�������
   * @param params Object[] �洢���̲���
   * @param paramTypes Type[] �洢���̲�������
   * @param attrMap     �洢���̷���ֵ�� map
   * @return ����resultClass���һ������б�
   */
  public List querySp(String spSql, Session session, Class resultClass,
	  Object[] params, Type[] paramTypes, Map attrMap) throws
      SpException {

    SQLQuery sqlQuery = session.createSQLQuery(spSql);

    sqlQuery.setParameters(params, paramTypes);

    putAttrMap(attrMap, sqlQuery);

    List list = sqlQuery.list();

    String[] attributeNames = (String[]) attrMap.keySet().toArray(new String[0]);

    List results = new ArrayList();
    try {
      for (int i = 0; i < list.size(); i++) {

        Object bean = resultClass.newInstance();

        if (attributeNames.length == 1) {
          Object row = list.get(i);

          PropertyUtils.setProperty(bean, attributeNames[0], row);


        }
        else {

          Object[] row = (Object[]) list.get(i);

          for (int j = 0; j < row.length; j++) {
            if (row[j] != null) {
              PropertyUtils.setProperty(bean, attributeNames[j], row[j]);
            }
          }
        }

        results.add(bean);
      }
    }
    catch (Exception e) {
      throw new SpException(e);
    }

    return results;
  }

  private void putAttrMap(Map attrMap, SQLQuery sqlQuery) {
    for (Iterator iterator = attrMap.entrySet().iterator();
         iterator.hasNext(); ) {
      Map.Entry entry = (Map.Entry) iterator.next();
      String attrName = (String) entry.getKey();
      Type attrType = (Type) entry.getValue();

      sqlQuery.addScalar(attrName, attrType);
    }
  }
}
