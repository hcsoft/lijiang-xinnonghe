package com.szgr.framework.authority.datarights;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.szgr.framework.util.TypeChecker;


/**
 * ��List����Ļ���������һЩ���û�������
 * 
 * @author huchunhe
 * 
 */
public class ListUtil {
	public ListUtil() {
	}

	/**
	 * �������Listת��Ϊ�ַ������顣
	 * 
	 * @param pList
	 *            list ��Ҫת����List
	 * @return String[] �ַ�������
	 */
	public static String[] stringListToStringArray(List<String> pList)
			throws Exception {
		if (!TypeChecker.isEmpty(pList)) {
			return pList.toArray(new String[pList.size()]);
		} else {
			throw new Exception("���˲���ListΪnull��Ϊ��");
		}
	}

	/**
	 * ȡ������List�в��ظ��ļ��ϡ�
	 * 
	 * @param list1
	 *            List ��һ��List
	 * @param list2
	 *            List �ڶ���List
	 * @return List List����
	 */
	public static List<Object> sumList(List<Object> list1, List<Object> list2) {
		List<Object> retList = null;
		if (!TypeChecker.isEmpty(list1) && !TypeChecker.isEmpty(list2)) {
			retList = uniteOfList(list1, list2);
			List<Object> inList = intersectionOfList(list1, list2);
			for (int i = 0; i < inList.size(); i++) {
				retList.remove(inList.get(i));
			}
		} else if (TypeChecker.isEmpty(list1) && TypeChecker.isEmpty(list2)) {
			retList = new ArrayList<Object>(1);
		} else if (TypeChecker.isEmpty(list1)) {
			retList = list2;
		} else {
			retList = list1;
		}
		return retList;
	}

	/**
	 * ȡ������List�Ľ�����
	 * 
	 * @param list1
	 *            List ��һ��List
	 * @param list2
	 *            List �ڶ���List
	 * @return ����List
	 */
	public static List<Object> intersectionOfList(List<Object> list1, List<Object> list2) {
		Iterator<Object> it = list2.iterator();
		List<Object> intersections = new ArrayList<Object>();
		while (it.hasNext()) {
			Object obj = it.next();
			if (list1.contains(obj)) {
				intersections.add(obj);
			}
		}
		return intersections;
	}

	/**
	 * ȡ������List�Ĳ�����
	 * 
	 * @param list1
	 *            List ��һ��List
	 * @param list2
	 *            List �ڶ���List
	 * @return List ����List
	 */
	public static List<Object> uniteOfList(List<Object> list1, List<Object> list2) {
		List<Object> retList = new ArrayList<Object>(list1.size() + list2.size());
		Iterator<Object> it1 = list1.iterator();
		Iterator<Object> it2 = list2.iterator();
		while (it1.hasNext()) {
			retList.add(it1.next());
		}
		while (it2.hasNext()) {
			retList.add(it2.next());
		}
		return retList;
	}

	/**
	 * �ж�List�еļ��������Ƿ��ظ���
	 * 
	 * @param rs
	 *            List list����
	 * @return boolean �ظ���true�����ظ���Ϊfalse
	 */
	public static boolean isRepeateList(List<Object> rs) {
		if (TypeChecker.isEmpty(rs)) {
			return false;
		}
		Set<Object> set = new HashSet<Object>(rs);
		return !(set.size() == rs.size());
	}

	/**
	 * list�����Ƿ������������е�ȫ��Ԫ�ء�
	 * 
	 * @param list1
	 *            List ����List1
	 * @param list2
	 *            List ����List2
	 * @return boolean ����Ϊtrue��������Ϊfalse
	 */
	public static boolean containAll(List<Object> list1, List<Object> list2) {
		if (TypeChecker.isEmpty(list1)) {
			list1 = new ArrayList<Object>(1);
		}
		if (TypeChecker.isEmpty(list2)) {
			list2 = new ArrayList<Object>(1);
		}
		return list1.containsAll(list2);
	}

	/**
	 * ɾ��������е��ظ����ȡ���ظ��ģ����
	 * 
	 * @param list
	 *            List Ŀ�꼯��List �����ɹ���ǰ���������б��еĶ�����������ͬ���ڴ����
	 * @return List �������list
	 */
	public static List<Object> getNoRepeatedList(List<Object> list) {
		List<Object> temp = new ArrayList<Object>();
		Set<Object> set = new HashSet<Object>(list);
		Iterator<Object> it = set.iterator();
		while (it.hasNext()) {
			temp.add(it.next());
		}
		return temp;
	}

	  /**
	   * ��map��ȡ�ź����list����������б����
	   * @param resmap HashMap
	   * @return List
	   */
	  public static List getSortedListfromMap(HashMap resmap) {
	    List reslist = new ArrayList();
	    Iterator iter = resmap.values().iterator();
	    int size = resmap.size();
	    Object[] keyarray = resmap.keySet().toArray();
	    Arrays.sort(keyarray);
	    for (int i = 0; i < size; i++) {
	      OptionObject optionObj = (OptionObject) resmap.get(keyarray[i].toString());
	      reslist.add(optionObj);
	    }
	    return reslist;

	  }

}
