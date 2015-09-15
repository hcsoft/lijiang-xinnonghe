package com.szgr.framework.authority.options;

import java.util.List;

public class OptionBean {
	/**
	 * ��ǰϵͳ�û����ؼ���
	 */
	private String userAuthorizion;

	/**
	 * ���л���
	 */
	private List taxSupOrgOption;
	/**
	 * ���ػ���
	 */
	private List taxOrgOption;
	/**
	 * ���ջ���
	 */
	private List taxDeptOption;
	/**
	 * ˰�չ���Ա
	 */
	private List taxEmpOption;

	/**
	 * ��Ʊ���ʹ���
	 */
	private List invClasstypeOption;

	/**
	 * ��Ʊ�������
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
