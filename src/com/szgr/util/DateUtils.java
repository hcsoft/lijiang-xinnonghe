package com.szgr.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class DateUtils {
	private static final Map<Integer,Integer> quarterMap = new HashMap<Integer,Integer>();
	private static final Map<Integer,Integer> halfYearMap = new HashMap<Integer,Integer>();
	
    private DateUtils(){}
    
    public static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    public static Date addDay(int daynum){
    	return addDay(new Date(),daynum);
    }
    public static Date addDay(Date date,int daynum){
    	Calendar c = Calendar.getInstance();
    	c.setTime(date);
    	c.add(Calendar.DAY_OF_MONTH, daynum);
    	return c.getTime();
    }
    public static Date nextDay(Date date){
    	return addDay(date,1);
    }
    /**
     * Month Ϊ0,1,2...........11
     * @param date
     * @return
     */
    public static Date getLastDayOfYear(Date date){
    	Calendar c = Calendar.getInstance();
    	c.setTime(date);
    	c.set(Calendar.MONTH,11);
    	c.set(Calendar.DAY_OF_MONTH,31);
    	return c.getTime();
    }
    
    public static Date getLastDayOfYearnotime(Date date){
    	String year = sdf.format(date).substring(0, 4);
	   	 try {
				return sdf.parse(year+"-12-31");
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return date;
    }
    /**
     * ��������մ���Date
     * @param year
     * @param month
     * @param day
     * @return
     */
    public static Date createDate(int year,int month,int day){
    	Calendar c = Calendar.getInstance();
    	c.set(Calendar.YEAR,year);
    	month = month == 12 ? 11:month-1;
    	c.set(Calendar.MONTH,month);
    	c.set(Calendar.DAY_OF_MONTH,day);
    	return c.getTime();
    }
    /**
     * ��ȡĳ���µĵ�һ��
     * @param date
     * @return
     */
    public static Date getFirstOfMonthDay(Date date){
    	Calendar c = Calendar.getInstance();
    	c.setTime(date);
    	c.set(Calendar.DAY_OF_MONTH, 1);
    	return c.getTime();
    }
    /**
     * ��ȡdate������µ����һ��
     * @param date
     * @return
     */
    public static Date getLastOfMonthDay(Date date){
    	Calendar c = Calendar.getInstance();
    	c.setTime(date);
    	c.add(Calendar.MONTH,1);
    	c.set(Calendar.DAY_OF_MONTH, 1);
    	c.add(Calendar.DAY_OF_MONTH, -1);
    	return c.getTime();
    }
    /**
     * ��ȡ��������֮����������,d1<=d2
     * ���d1,d2��һ�������棬�򷵻�1��
     * @param d1
     * @param d2
     * @return
     */
    public static int getDateSplitMonth(Date d1,Date d2){
    	Calendar c1 = Calendar.getInstance();
    	c1.setTime(d1);
    	
    	Calendar c2 = Calendar.getInstance();
    	c2.setTime(d2);
    	
    	int result = 0;
    	while((c1.get(Calendar.YEAR) * 100 + c1.get(Calendar.MONTH)) <= (c2.get(Calendar.YEAR) * 100 + c2.get(Calendar.MONTH)) ){
    		result++;
    		c1.add(Calendar.MONTH,1);
    	}
    	return result;
    	
    }
    /**
     * ��ȡĳ��ĳ���ж�����
     * @param year
     * @param month
     * @return
     */
    public static int getDayOfMonth(int year,int month){
    	Date d = createDate(year, month, 1);
    	return getDayOfMonth(d);
    }
    /**
     * ��ȡ�������ڵ��ꡢ���ж�����
     * @param date
     * @return
     */
    public static int getDayOfMonth(Date date){
    	Date lastDay = getLastOfMonthDay(date);
    	Calendar c = Calendar.getInstance();
    	c.setTime(lastDay);
    	return c.get(Calendar.DAY_OF_MONTH);
    }
    /**
     * ��ȡͬһ���µ����������������죬d1<=d2
     * @param d1
     * @param d2
     * @return
     */
    public static int getDayOfSameMonth(Date d1,Date d2){
    	Calendar c1 = Calendar.getInstance();
    	c1.setTime(d1);
    	
    	Calendar c2 = Calendar.getInstance();
    	c2.setTime(d2);
    	
    	int begin = c1.get(Calendar.DAY_OF_MONTH);
    	int end = c2.get(Calendar.DAY_OF_MONTH);
    	return end-begin+1;
    	
    }
    /**
     * �Ƚ����������Ƿ���ȣ�ֻ�Ƚ�������
     * @param d1
     * @param d2
     * @return
     */
    public static boolean isYMDEqual(Date d1,Date d2){
    	if(d1 == null || d2 == null)
    		return false;
    	String str1 = sdf.format(d1);
    	String str2 = sdf.format(d2);
    	return str1.equals(str2);
    }
    /**
     * �����ڽ�����û�����·���
     * @param d
     * @return
     */
    public static Date parseDateNotMinSecond(Date d){
    	String strDate = parseDate(d);
    	Date result = null;
		try {
			result = sdf.parse(strDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	return result;
    }
    public static String parseDate(Date d){
    	if(d == null)
    		return "";
    	return sdf.format(d);
    }
    /**
     * ��ȡ�����
     * @see Constants
     * @return
     */
    public static int getHalfYear(Date d){
    	Calendar c = Calendar.getInstance();
    	c.setTime(d);
    	int month = c.get(Calendar.MONTH);
    	return halfYearMap.get(month);
    }
    /**
     * ��ȡ����
     * @see Constants
     * @return
     */
    public static int getQuarter(Date d){
    	Calendar c = Calendar.getInstance();
    	c.setTime(d);
    	int month = c.get(Calendar.MONTH);
    	return quarterMap.get(month);
    }
    public static int getYear(Date d){
    	Calendar c = Calendar.getInstance();
    	c.setTime(d);
    	return c.get(Calendar.YEAR);
    }
    
    public static String getCurrentDate(){
		 return parseDate(Calendar.getInstance().getTime());
	}
    
    public static int getMonth(Date d){
    	Calendar c = Calendar.getInstance();
    	c.setTime(d);
    	int month = c.get(Calendar.MONTH);
    	return month+1;
    }
    public static boolean isLastMonthOfYear(Date d){
    	return getMonth(d) == 12;
    }
    
}
