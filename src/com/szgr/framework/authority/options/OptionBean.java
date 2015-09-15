package com.szgr.framework.authority.options;

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

	/**
	 * 发票类型代码
	 */
	private List invClasstypeOption;

	/**
	 * 发票种类代码
	 */
	private List invoiceOption;

	public List getInvClasstypeOption() {
		return invClasstypeOption;
	}

	public List getInvoiceOption() {
		return invoiceOption;
	}

	public void setInvClasstypeOption(List invClasstypeOption) {
		this.invClasstypeOption = invClasstypeOption;
	}

	public void setInvoiceOption(List invoiceOption) {
		this.invoiceOption = invoiceOption;
	}

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
