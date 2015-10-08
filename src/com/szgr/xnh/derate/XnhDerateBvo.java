package com.szgr.xnh.derate;

import java.math.BigDecimal;

import com.szgr.vo.XnhDerateVO;

public class XnhDerateBvo extends XnhDerateVO{
	
	private String derate_date_year;
	private String derate_date_yearmonth;
	private String derate_date_yearmonthday;
	private String union_id;
	private BigDecimal derate_type10;
	private BigDecimal derate_type20;
	private String user_name;
	

	private int currentpagenum;
	private int pagesize;
	private int totalitemsnum;
	private int totalpagenum;
	
	
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getDerate_date_year() {
		return derate_date_year;
	}
	public void setDerate_date_year(String derate_date_year) {
		this.derate_date_year = derate_date_year;
	}
	public String getDerate_date_yearmonth() {
		return derate_date_yearmonth;
	}
	public void setDerate_date_yearmonth(String derate_date_yearmonth) {
		this.derate_date_yearmonth = derate_date_yearmonth;
	}
	public String getDerate_date_yearmonthday() {
		return derate_date_yearmonthday;
	}
	public void setDerate_date_yearmonthday(String derate_date_yearmonthday) {
		this.derate_date_yearmonthday = derate_date_yearmonthday;
	}
	public String getUnion_id() {
		return union_id;
	}
	public void setUnion_id(String union_id) {
		this.union_id = union_id;
	}
	public BigDecimal getDerate_type10() {
		return derate_type10;
	}
	public void setDerate_type10(BigDecimal derate_type10) {
		this.derate_type10 = derate_type10;
	}
	public BigDecimal getDerate_type20() {
		return derate_type20;
	}
	public void setDerate_type20(BigDecimal derate_type20) {
		this.derate_type20 = derate_type20;
	}
	public int getCurrentpagenum() {
		return currentpagenum;
	}
	public void setCurrentpagenum(int currentpagenum) {
		this.currentpagenum = currentpagenum;
	}
	public int getPagesize() {
		return pagesize;
	}
	public void setPagesize(int pagesize) {
		this.pagesize = pagesize;
	}
	public int getTotalitemsnum() {
		return totalitemsnum;
	}
	public void setTotalitemsnum(int totalitemsnum) {
		this.totalitemsnum = totalitemsnum;
	}
	public int getTotalpagenum() {
		return totalpagenum;
	}
	public void setTotalpagenum(int totalpagenum) {
		this.totalpagenum = totalpagenum;
	}
	
	
}
