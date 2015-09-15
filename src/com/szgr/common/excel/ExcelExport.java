package com.szgr.common.excel;

import java.util.List;

/**
* 
* <p>Title: ExcelExport.java</p>
* <p>Description: Excel导出</p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-7-31
* @version 1.0
 */
public interface ExcelExport {
	
	String DOWNLOADPATH = "download";
	 /**
	  * 把dataList导出
	  * @param model
	  * @return
	  */
    public String export(List dataList) throws ExcelException;
    /**
     * 数据完全导入后进行的处理，比如合并单元格之类的
     */
    public void processAfterDataWriteComplete();
 	 
}