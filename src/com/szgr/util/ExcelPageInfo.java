package com.szgr.util;
/**
 * 
* <p>Title: ExcelPageInfo.java</p>
* <p>Description:具有Excel相关的属性 </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-12-25
* @version 1.0
 */
public class ExcelPageInfo extends PageInfo{
	//excel导出的属性
    private String propNames;
    private String colNames;
    private String modelName;
	public String getPropNames() {
		return propNames;
	}
	public void setPropNames(String propNames) {
		this.propNames = propNames;
	}
	public String getColNames() {
		return colNames;
	}
	public void setColNames(String colNames) {
		this.colNames = colNames;
	}
	public String getModelName() {
		return modelName;
	}
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}
    
}
