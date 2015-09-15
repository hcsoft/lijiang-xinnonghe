package com.szgr.common.excel;

import org.json.simple.JSONObject;

import com.szgr.util.PageInfo;

public interface IExcelExportExecute {
   
	int FETCH_ROW = 500;
		
	public JSONObject execute(PageInfo pageInfo);
   
}
