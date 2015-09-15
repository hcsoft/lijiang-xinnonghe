package com.szgr.common.upload;

public class AttachmentBo {

	private String attachmentcode;
	private String attachmentname;
	private String businesscode;
	private String isdefault;
	private String taxempcode;

	public String getBusinesscode() {
		return businesscode;
	}

	public void setBusinesscode(String businesscode) {
		this.businesscode = businesscode;
	}

	public String getAttachmentcode() {
		return attachmentcode;
	}

	public void setAttachmentcode(String attachmentcode) {
		this.attachmentcode = attachmentcode;
	}

	public String getAttachmentname() {
		return attachmentname;
	}

	public void setAttachmentname(String attachmentname) {
		this.attachmentname = attachmentname;
	}

	public String getIsdefault() {
		return isdefault;
	}

	public void setIsdefault(String isdefault) {
		this.isdefault = isdefault;
	}

	public String getTaxempcode() {
		return taxempcode;
	}

	public void setTaxempcode(String taxempcode) {
		this.taxempcode = taxempcode;
	}

}
