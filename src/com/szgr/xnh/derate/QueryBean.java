package com.szgr.xnh.derate;

import com.szgr.vo.XnhUserVO;

public class QueryBean extends XnhUserVO{
	
	private String page;
	private String rows;
	public String getPage() {
		return page;
	}
	public void setPage(String page) {
		this.page = page;
	}
	public String getRows() {
		return rows;
	}
	public void setRows(String rows) {
		this.rows = rows;
	}
	
	
}
