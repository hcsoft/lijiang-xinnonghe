package com.szgr.common.excel;

import java.util.List;

/**
* 
* <p>Title: ExcelExport.java</p>
* <p>Description: Excel����</p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-7-31
* @version 1.0
 */
public interface ExcelExport {
	
	String DOWNLOADPATH = "download";
	 /**
	  * ��dataList����
	  * @param model
	  * @return
	  */
    public String export(List dataList) throws ExcelException;
    /**
     * ������ȫ�������еĴ�������ϲ���Ԫ��֮���
     */
    public void processAfterDataWriteComplete();
 	 
}