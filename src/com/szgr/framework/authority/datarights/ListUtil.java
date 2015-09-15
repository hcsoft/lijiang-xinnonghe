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
 * 对List对象的基本操作的一些常用基本处理。
 * 
 * @author huchunhe
 * 
 */
public class ListUtil {
	public ListUtil() {
	}

	/**
	 * 将传入的List转换为字符串数组。
	 * 
	 * @param pList
	 *            list 需要转换的List
	 * @return String[] 字符串数组
	 */
	public static String[] stringListToStringArray(List<String> pList)
			throws Exception {
		if (!TypeChecker.isEmpty(pList)) {
			return pList.toArray(new String[pList.size()]);
		} else {
			throw new Exception("传人参数List为null或为空");
		}
	}

	/**
	 * 取得两个List中不重复的集合。
	 * 
	 * @param list1
	 *            List 第一个List
	 * @param list2
	 *            List 第二个List
	 * @return List List集合
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
	 * 取得两个List的交集。
	 * 
	 * @param list1
	 *            List 第一个List
	 * @param list2
	 *            List 第二个List
	 * @return 交集List
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
	 * 取得两个List的并集。
	 * 
	 * @param list1
	 *            List 第一个List
	 * @param list2
	 *            List 第二个List
	 * @return List 并集List
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
	 * 判断List中的集合数据是否重复。
	 * 
	 * @param rs
	 *            List list集合
	 * @return boolean 重复则true，不重复则为false
	 */
	public static boolean isRepeateList(List<Object> rs) {
		if (TypeChecker.isEmpty(rs)) {
			return false;
		}
		Set<Object> set = new HashSet<Object>(rs);
		return !(set.size() == rs.size());
	}

	/**
	 * list１中是否包含ｌｉｓｔ２中的全部元素。
	 * 
	 * @param list1
	 *            List 集合List1
	 * @param list2
	 *            List 集合List2
	 * @return boolean 是则为true，不是则为false
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
	 * 删除ｌｉｓｔ中的重复项，获取不重复的ｌｉｓｔ
	 * 
	 * @param list
	 *            List 目标集合List 操作成功的前提是两个列表中的对象来自于相同的内存对象
	 * @return List 结果集合list
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
	   * 从map获取排好序的list，针对下拉列表操作
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
