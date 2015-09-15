package com.szgr.common.excel;

import java.util.LinkedHashMap;

/**
* 
* <p>Title: ExcelModel.java</p>
* <p>Description:Excel������ģ�� </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-7-31
* @version 1.0
*/
public interface ExcelExportModel {
	 /**
	  * ��Ҫ�������Ҫ����List<Object>,Object�����Ժ���Excel���е���ʾ�Ķ���
	  * 
	  * @return
	  */
     LinkedHashMap<String,String> getHeadDisplayInfo();
     /**
      * ��Excel�п�ʼд����
      * @return
      */
     int getStartRow();
     /**
      * ��Excel�п�ʼд����
      * @return
      */
     int getStartCol();
     
     /**
      * ��ȡģ�����ƣ�����Ӧ��˰����ͳ�ƣ���Ϊsheet������
      * @return
      */
     String getModelName();
     
     String getFileName();
     
     public String[] getHiddenPropertys();
     
     public void setHiddenProperty(String[] hiddenPropertys);
     
     public short getHeadBackGroudColor();
     
  	 public void setHeadBackGroudColor(short headBackGroudColor);
     
}
