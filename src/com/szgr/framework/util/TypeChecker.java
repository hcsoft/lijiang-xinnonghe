package com.szgr.framework.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * Title: ynds
 * </p>
 * 
 * <p>
 * Description: TM
 * </p>
 * 
 * <p>
 * Copyright: Copyright (c) 2005
 * </p>
 * 
 * <p>
 * Company: thtf
 * </p>
 * 
 * @author yqs
 * @version 1.1
 */

public class TypeChecker {
	/*
	 * 不需要logger private static final Log logger =
	 * LogFactory.getLog(TypeChecker.class);
	 */

	/**
	 * 是否为整形数
	 * 
	 * @param str -
	 *            待检查字符串
	 * @return boolean
	 * @roseuid 3F39FE470229
	 */
	public static boolean isInteger(String str) {
		try {
			Integer.parseInt(str);
		} catch (Exception ex) {
			return false;
		} // end try catch
		return true;
	}

	/**
	 * 判断是否是合法的长整型
	 * 
	 * @param str
	 *            输入的字符串
	 * @return boolean
	 * @roseuid 3F39FE470233
	 */
	public static boolean isLong(String str) {
		try {
			Long.parseLong(str);
		} catch (Exception ex) {
			return false;
		} // end try catch
		return true;
	}

	/**
	 * 是否为浮点数。
	 * 
	 * @param str -
	 *            待检查字符串
	 * @return boolean
	 * @roseuid 3F39FE470250
	 */
	public static boolean isFloat(String str) {
		try {
			float tmp = Float.parseFloat(str);
			return true;
		} catch (NumberFormatException e) {
			return false;
		} // end try - catch
	}

	/**
	 * 是否为数字。
	 * 
	 * @param str -
	 *            待检查字符串
	 * @return boolean
	 * @roseuid 3F39FE47025B
	 */
	public static boolean isNumber(String str) {
		try {
			double tmp = Double.parseDouble(str);
			return true;
		} catch (NumberFormatException e) {
			return false;
		} // end try - catch
	}

	/**
	 * 是否为日期，必须使用2002-12-12格式，月份和天一位时必须有前导零
	 * 
	 * @param str -
	 *            待检查字符串
	 * @return boolean
	 * @roseuid 3F39FE470265
	 */
	public static boolean isDate(String str) {
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat(
				"yyyy-MM-dd");
		try {
			java.util.Date date = df.parse(str);
			// 是否变形
			String apple = df.format(date);
			if (!apple.equals(str)) {
				return false;
			}
		} catch (Exception ex) {
			return false;
		} // end try - catch
		return true;
	}

	/**
	 * 是否为合法的日期时间，格式为2002-02-02 15:00:03 .
	 * 
	 * @param str -
	 *            待检查字符串
	 * @return boolean
	 * @roseuid 3F39FE470278
	 */
	public static boolean isDatetime(String str) {
		if (str.length() < 19) {
			return false;
		}

		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss.SSS");
		java.text.SimpleDateFormat df400 = new java.text.SimpleDateFormat(
				"yyyy-MM-dd-HH.mm.ss.SSS");
		// 补上点
		if (!str.endsWith(".") && str.length() == 19) {
			str = str + ".";
		} // end if
		// 补充长度
		while (str.length() < 23) {
			str = str + "0";
		} // end while
		try {
			java.util.Date date = df.parse(str);
			// 是否变形
			String apple = df.format(date);
			if (!apple.equals(str)) {
				return false;
			}
		} catch (java.text.ParseException ex) {
			try {
				java.util.Date date2 = df400.parse(str);
				// 是否变形
				String apple1 = df400.format(date2);
				if (!apple1.equals(str)) {
					return false;
				}
			} catch (java.text.ParseException exa) {
				exa.printStackTrace();
				return false;
			}
			return true;
		}
		return true;
	}

	/**
	 * 是否为合法的Double
	 * 
	 * @param str -
	 *            待检查字符串
	 * @return boolean
	 */
	public static boolean isDouble(String str) {
		try {
			double tmp = Double.parseDouble(str);
			return true;
		} catch (Exception ex) {
			return false;

		}

	}

	/**
	 * 是否为合法的Decimal
	 * 
	 * @param str -
	 *            待检查字符串
	 * @return boolean
	 */

	public static void isDecimal(String decimal) throws Exception {
		if (isEmpty(decimal))
			return;
		int commaPos = decimal.indexOf(",");
		if (commaPos < 1)
			throw new Exception(decimal + " Decimal格式必须包含逗号如10,2");
		int fractionValue = Integer.parseInt(decimal.substring(commaPos + 1));
		int integerValue = (Integer.parseInt(decimal.substring(0, commaPos)) - fractionValue) + 1;
		if (integerValue < 1 || fractionValue < 0)
			throw new Exception(decimal + " Decimal格式不正确!");
		if (fractionValue == 0)
			throw new Exception("Type中decimal替换成integer");
		else
			return;
	}

	private static boolean isleagueChar4Char(String regexp, String value)
			throws Exception {
		Matcher matcher;
		Pattern pattern = Pattern.compile(regexp);
		matcher = pattern.matcher(value);
		return matcher.matches();

	}

	public static boolean isEmpty(String str) {
		return str == null || str.trim().equals("");
	}

	public static boolean isEmpty(String str[]) {
		return str == null || str.length <= 0;
	}

	public static boolean isEmptyStringBuffer(StringBuffer strbuffer) {
		return strbuffer == null || strbuffer.length() <= 0;
	}

	public static boolean isEmpty(Map map) {
		return map == null || map.isEmpty();
	}

	public static boolean isEmptylist(List list) {
		return list == null || list.isEmpty();
	}

	public static boolean isEmpty(Collection collection) {
		return collection == null || collection.isEmpty();
	}

	public static boolean isEmpty(ArrayList arrayList) {
		return arrayList == null || arrayList.isEmpty();
	}

	public static boolean isNull(Object obj) {
		return obj == null;
	}

}
