package com.szgr.util;

public class PageInfo {
	/**
	 * ��һҳ
	 */
	
	private Integer page = 1;
	
	/**
	 * ҳ��С ҳ��ͨ�������������������jquery���ǵ���rows����
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
