package com.szgr.util;

public class PageInfo {
	/**
	 * 哪一页
	 */
	
	private Integer page = 1;
	
	/**
	 * 页大小 页面通过传递这个参数过来，jquery覆盖掉了rows参数
	 */
	private Integer pagesize = 15;
	
	public Integer getPagesize() {
		return pagesize;
	}
	public void setPagesize(Integer pagesize) {
		this.pagesize = pagesize;
	}
	public Integer getPage() {
		return page;
	}
	public void setPage(Integer page) {
		this.page = page;
	}
	
	private Integer rows = 15;
	
	public Integer getRows() {
		return this.rows;
	}
	public void setRows(Integer rows) {
		this.rows = rows;
	}
	
	
	
}
