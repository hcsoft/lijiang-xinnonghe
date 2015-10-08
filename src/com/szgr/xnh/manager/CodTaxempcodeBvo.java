package com.szgr.xnh.manager;

import java.util.HashMap;
import java.util.List;

import com.thtf.ynds.vo.CodTaxempcodeVO;

public class CodTaxempcodeBvo extends CodTaxempcodeVO{
	
	private String page;
	private String rows;
	private HashMap<String, List> role_ids ;
	private List roles;
	
	
	public List getRoles() {
		return roles;
	}
	public void setRoles(List roles) {
		this.roles = roles;
	}
	public HashMap<String, List> getRole_ids() {
		return role_ids;
	}
	public void setRole_ids(HashMap<String, List> role_ids) {
		this.role_ids = role_ids;
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
