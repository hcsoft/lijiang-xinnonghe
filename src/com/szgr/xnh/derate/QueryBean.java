package com.szgr.xnh.derate;

import com.szgr.vo.XnhUserVO;

public class QueryBean extends XnhUserVO{
	
	private String sumtype;
	private String opt_orgcode;
	private String deratedatebegin;
	private String deratedateend;
	
	private String page;
	private String rows;
	private String derate_type;
	
	
	public String getSumtype() {
		return sumtype;
	}
	public void setSumtype(String sumtype) {
		this.sumtype = sumtype;
	}
	public String getOpt_orgcode() {
		return opt_orgcode;
	}
	public void setOpt_orgcode(String opt_orgcode) {
		this.opt_orgcode = opt_orgcode;
	}
	public String getDeratedatebegin() {
		return deratedatebegin;
	}
	public void setDeratedatebegin(String deratedatebegin) {
		this.deratedatebegin = deratedatebegin;
	}
	public String getDeratedateend() {
		return deratedateend;
	}
	public void setDeratedateend(String deratedateend) {
		this.deratedateend = deratedateend;
	}
	public String getDerate_type() {
		return derate_type;
	}
	public void setDerate_type(String derate_type) {
		this.derate_type = derate_type;
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
