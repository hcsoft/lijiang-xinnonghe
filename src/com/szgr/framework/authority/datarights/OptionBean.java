package com.szgr.framework.authority.datarights;

import java.util.List;

public class OptionBean {
	/**
	 * 当前系统用户机关级别
	 */
	private String userAuthorizion;

	/**
	 * 州市机关
	 */
	private List taxSupOrgOption;
	/**
	 * 区县机关
	 */
	private List taxOrgOption;
	/**
	 * 征收机关
	 */
	private List taxDeptOption;
	/**
	 * 税收管理员
	 */
	private List taxEmpOption;

	public String getUserAuthorizion() {
		return userAuthorizion;
	}

	public void setUserAuthorizion(String userAuthorizion) {
		this.userAuthorizion = userAuthorizion;
	}

	public List getTaxSupOrgOption() {
		return taxSupOrgOption;
	}

	public void setTaxSupOrgOption(List taxSupOrgOption) {
		this.taxSupOrgOption = taxSupOrgOption;
	}

	public List getTaxOrgOption() {
		return taxOrgOption;
	}

	public void setTaxOrgOption(List taxOrgOption) {
		this.taxOrgOption = taxOrgOption;
	}

	public List getTaxDeptOption() {
		return taxDeptOption;
	}

	public void setTaxDeptOption(List taxDeptOption) {
		this.taxDeptOption = taxDeptOption;
	}

	public List getTaxEmpOption() {
		return taxEmpOption;
	}

	public void setTaxEmpOption(List taxEmpOption) {
		this.taxEmpOption = taxEmpOption;
	}
}
