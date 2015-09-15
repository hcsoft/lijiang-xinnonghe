package com.szgr.util;

public class BaseQueryCondition extends PageInfo{

	private String taxorgsupcode;
	private String taxorgcode;
	private String taxdeptcode;
	private String taxmanagercode;
	private String taxpayerid;
	private String taxpayername;

	public String getTaxorgsupcode() {
		return taxorgsupcode;
	}

	public void setTaxorgsupcode(String taxorgsupcode) {
		this.taxorgsupcode = taxorgsupcode;
	}

	public String getTaxorgcode() {
		return taxorgcode;
	}

	public void setTaxorgcode(String taxorgcode) {
		this.taxorgcode = taxorgcode;
	}

	public String getTaxdeptcode() {
		return taxdeptcode;
	}

	public void setTaxdeptcode(String taxdeptcode) {
		this.taxdeptcode = taxdeptcode;
	}

	public String getTaxmanagercode() {
		return taxmanagercode;
	}

	public void setTaxmanagercode(String taxmanagercode) {
		this.taxmanagercode = taxmanagercode;
	}

	public String getTaxpayerid() {
		return taxpayerid;
	}

	public void setTaxpayerid(String taxpayerid) {
		this.taxpayerid = taxpayerid;
	}

	public String getTaxpayername() {
		return taxpayername;
	}

	public void setTaxpayername(String taxpayername) {
		this.taxpayername = taxpayername;
	}
	public String getBaseWhere() {
		StringBuffer sb = new StringBuffer();
		if (StringUtils.notEmpty(this.taxorgsupcode)) {
			sb.append(" and taxorgsupcode = '" + taxorgsupcode + "' ");
		}
		if (StringUtils.notEmpty(this.taxorgcode)) {
			sb.append(" and taxorgcode = '" + taxorgcode + "' ");
		}
		if (StringUtils.notEmpty(this.taxdeptcode)) {
			sb.append(" and taxdeptcode = '" + taxdeptcode + "' ");
		}
		if (StringUtils.notEmpty(this.taxmanagercode)) {
			sb.append(" and taxmanagercode = '" + taxmanagercode + "' ");
		}
		if (StringUtils.notEmpty(this.taxpayerid)) {
			sb.append(" and taxpayerid = '" + taxpayerid + "' ");
		}
		if (StringUtils.notEmpty(this.taxpayername)) {
			sb.append(" and taxpayername like '%" + taxpayername + "%' ");
		}
		return sb.toString();
	}

}
