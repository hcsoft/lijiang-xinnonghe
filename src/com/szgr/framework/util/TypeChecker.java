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
	 * ����Ҫlogger private static final Log logger =
	 * LogFactory.getLog(TypeChecker.class);
	 */

	/**
	 * �Ƿ�Ϊ������
	 * 
	 * @param str -
	 *            ������ַ���
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
	 * �ж��Ƿ��ǺϷ��ĳ�����
	 * 
	 * @param str
	 *            ������ַ���
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
	 * �Ƿ�Ϊ��������
	 * 
	 * @param str -
	 *            ������ַ���
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
	 * �Ƿ�Ϊ���֡�
	 * 
	 * @param str -
	 *            ������ַ���
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
	 * �Ƿ�Ϊ���ڣ�����ʹ��2002-12-12��ʽ���·ݺ���һλʱ������ǰ����
	 * 
	 * @param str -
	 *            ������ַ���
	 * @return boolean
	 * @roseuid 3F39FE470265
	 */
	public static boolean isDate(String str) {
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat(
				"yyyy-MM-dd");
		try {
			java.util.Date date = df.parse(str);
			// �Ƿ����
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
	 * �Ƿ�Ϊ�Ϸ�������ʱ�䣬��ʽΪ2002-02-02 15:00:03 .
	 * 
	 * @param str -
	 *            ������ַ���
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
		// ���ϵ�
		if (!str.endsWith(".") && str.length() == 19) {
			str = str + ".";
		} // end if
		// ���䳤��
		while (str.length() < 23) {
			str = str + "0";
		} // end while
		try {
			java.util.Date date = df.parse(str);
			// �Ƿ����
			String apple = df.format(date);
			if (!apple.equals(str)) {
				return false;
			}
		} catch (java.text.ParseException ex) {
			try {
				java.util.Date date2 = df400.parse(str);
				// �Ƿ����
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
	 * �Ƿ�Ϊ�Ϸ���Double
	 * 
	 * @param str -
	 *            ������ַ���
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
	 * �Ƿ�Ϊ�Ϸ���Decimal
	 * 
	 * @param str -
	 *            ������ַ���
	 * @return boolean
	 */

	public static void isDecimal(String decimal) throws Exception {
		if (isEmpty(decimal))
			return;
		int commaPos = decimal.indexOf(",");
		if (commaPos < 1)
			throw new Exception(decimal + " Decimal��ʽ�������������10,2");
		int fractionValue = Integer.parseInt(decimal.substring(commaPos + 1));
		int integerValue = (Integer.parseInt(decimal.substring(0, commaPos)) - fractionValue) + 1;
		if (integerValue < 1 || fractionValue < 0)
			throw new Exception(decimal + " Decimal��ʽ����ȷ!");
		if (fractionValue == 0)
			throw new Exception("Type��decimal�滻��integer");
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
