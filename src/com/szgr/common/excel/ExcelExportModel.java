package com.szgr.common.excel;

import java.util.LinkedHashMap;

/**
* 
* <p>Title: ExcelModel.java</p>
* <p>Description:Excel导出的模板 </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-7-31
* @version 1.0
*/
public interface ExcelExportModel {
	 /**
	  * 主要是针对需要导出List<Object>,Object的属性和在Excel中列的显示的对照
	  * 
	  * @return
	  */
     LinkedHashMap<String,String> getHeadDisplayInfo();
     /**
      * 在Excel中开始写的行
      * @return
      */
     int getStartRow();
     /**
      * 在Excel中开始写的列
      * @return
      */
     int getStartCol();
     
     /**
      * 获取模板名称，比如应纳税汇总统计，作为sheet的名称
      * @return
      */
     String getModelName();
     
     String getFileName();
     
     public String[] getHiddenPropertys();
     
     public void setHiddenProperty(String[] hiddenPropertys);
     
     public short getHeadBackGroudColor();
     
  	 public void setHeadBackGroudColor(short headBackGroudColor);
     
}
