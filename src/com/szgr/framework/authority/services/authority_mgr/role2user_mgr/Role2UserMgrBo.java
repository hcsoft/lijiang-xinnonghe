package com.szgr.framework.authority.services.authority_mgr.role2user_mgr;

public class Role2UserMgrBo {
	private String serial_id;
	private String role_code;
	private String role_describe;
	private String taxempcode;
	private String taxempname;
	private String taxorgcode;

	public String getSerial_id() {
		return serial_id;
	}

	public void setSerial_id(String serial_id) {
		this.serial_id = serial_id;
	}

	public String getRole_code() {
		return role_code;
	}

	public void setRole_code(String role_code) {
		this.role_code = role_code;
	}

	public String getRole_describe() {
		return role_describe;
	}

	public void setRole_describe(String role_describe) {
		this.role_describe = role_describe;
	}

	public String getTaxempcode() {
		return taxempcode;
	}

	public void setTaxempcode(String taxempcode) {
		this.taxempcode = taxempcode;
	}

	public String getTaxorgcode() {
		return taxorgcode;
	}

	public void setTaxorgcode(String taxorgcode) {
		this.taxorgcode = taxorgcode;
	}

	public String getTaxempname() {
		return taxempname;
	}

	public void setTaxempname(String taxempname) {
		this.taxempname = taxempname;
	}

}
