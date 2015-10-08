package com.szgr.xnh.manager;

import com.szgr.vo.XnhNoticeVO;

public class NoticeBvo extends XnhNoticeVO{
	
	private String page;
	private String rows;
	private String optdatebegin;
	private String optdateend;
	private String readflag;
	
	
	public String getReadflag() {
		return readflag;
	}
	public void setReadflag(String readflag) {
		this.readflag = readflag;
	}
	public String getOptdatebegin() {
		return optdatebegin;
	}
	public void setOptdatebegin(String optdatebegin) {
		this.optdatebegin = optdatebegin;
	}
	public String getOptdateend() {
		return optdateend;
	}
	public void setOptdateend(String optdateend) {
		this.optdateend = optdateend;
	}
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
