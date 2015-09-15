package com.szgr.common.excel;

import com.szgr.common.excel.AbstractExcelExportModel;

public class DefaultExportModel extends AbstractExcelExportModel {
	
	private String modelName = null;
	
	public DefaultExportModel(String modelName, String keyStr,String nameStr,int startRow,int startCol){
		super(keyStr,nameStr,startRow,startCol);
	    this.modelName = modelName;
	}
	public DefaultExportModel(String modelName,String[] key,String[] name,int startRow,int startCol){
		super(key,name,startRow,startCol);
	    this.modelName = modelName;
	}
	public DefaultExportModel(String modelName,int startRow,int startCol){
		super(startRow,startCol);
		this.modelName = modelName;
	}
	
	public String getModelName() {
		return this.modelName;
	}
	
}
