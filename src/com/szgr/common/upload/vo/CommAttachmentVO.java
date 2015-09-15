package com.szgr.common.upload.vo;

//imports
import java.io.Serializable;
import java.math.BigDecimal;

/**
 * <p>
 * Title:COMM_ATTACHMENT
 * </p>
 * <p>
 * Description: COMM_ATTACHMENT,Hibernate ”≥…‰VO
 * </p>
 * <p>
 * Company: thtf yun nan Branch
 * </p>
 * 
 * @author PdmToVoGen1.0
 * @version 1.0
 * @create datetime 2013-05-29 17:06:35.528
 */

public class CommAttachmentVO implements Serializable {
	// Fields
	// attachmentid
	private java.lang.String attachmentid;
	// businesscode
	private java.lang.String businesscode;
	// businessnumber
	private java.lang.String businessnumber;
	// attachmentname
	private java.lang.String attachmentname;
	// attachmentcode
	private java.lang.String attachmentcode;
	// attachmentcode
	private BigDecimal filesize;
	// address
	private java.lang.String address;
	// uploaddate
	private java.util.Date uploaddate;
	// inputperson
	private java.lang.String inputperson;
	// isdefault
	private java.lang.String isdefault;
	
	private java.lang.String usercode;
	
	private java.lang.String attachmenttypename;
	

	private int muteFlag;

	// contructors
	public CommAttachmentVO() {
	}

	public CommAttachmentVO(java.lang.String attachmentid) {
		this.attachmentid = attachmentid;
	}
	
	public java.lang.String getUsercode() {
		return usercode;
	}

	public void setUsercode(java.lang.String usercode) {
		this.usercode = usercode;
	}
	
	

	public java.lang.String getAttachmenttypename() {
		return attachmenttypename;
	}

	public void setAttachmenttypename(java.lang.String attachmenttypename) {
		this.attachmenttypename = attachmenttypename;
	}

	// methods
	public java.lang.String getAttachmentid() {
		return this.attachmentid;
	}

	public void setAttachmentid(java.lang.String attachmentid) {
		this.attachmentid = attachmentid;
	}

	public java.lang.String getBusinesscode() {
		return this.businesscode;
	}

	public void setBusinesscode(java.lang.String businesscode) {
		this.businesscode = businesscode;
	}

	public java.lang.String getBusinessnumber() {
		return this.businessnumber;
	}

	public void setBusinessnumber(java.lang.String businessnumber) {
		this.businessnumber = businessnumber;
	}

	public java.lang.String getAttachmentname() {
		return this.attachmentname;
	}

	public void setAttachmentname(java.lang.String attachmentname) {
		this.attachmentname = attachmentname;
	}

	public java.lang.String getAttachmentcode() {
		return this.attachmentcode;
	}

	public void setAttachmentcode(java.lang.String attachmentcode) {
		this.attachmentcode = attachmentcode;
	}

	public java.lang.String getAddress() {
		return this.address;
	}

	public void setAddress(java.lang.String address) {
		this.address = address;
	}

	public java.util.Date getUploaddate() {
		return this.uploaddate;
	}

	public void setUploaddate(java.util.Date uploaddate) {
		this.uploaddate = uploaddate;
	}

	public java.lang.String getInputperson() {
		return this.inputperson;
	}

	public void setInputperson(java.lang.String inputperson) {
		this.inputperson = inputperson;
	}

	public BigDecimal getFilesize() {
		return filesize;
	}

	public void setFilesize(BigDecimal filesize) {
		this.filesize = filesize;
	}

	public java.lang.String getIsdefault() {
		return isdefault;
	}

	public void setIsdefault(java.lang.String isdefault) {
		this.isdefault = isdefault;
	}

	public void setMuteFlag(int muteFlag) {
		this.muteFlag = muteFlag;
	}

	public int getMuteFlag() {
		return muteFlag;
	}

	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("[businesscode:").append(businesscode).append("]");
		sb.append("[businessnumber:").append(businessnumber).append("]");
		sb.append("[attachmentname:").append(attachmentname).append("]");
		sb.append("[attachmentcode:").append(attachmentcode).append("]");
		sb.append("[address:").append(address).append("]");
		sb.append("[uploaddate:").append(uploaddate).append("]");
		sb.append("[inputperson:").append(inputperson).append("]");
		sb.append("[isdefault:").append(isdefault).append("]");
		sb.append("[usercode:").append(usercode).append("]");
		return sb.toString();
	}

	public int hashCode() {
		int result = 0;
		result = 29 * result
				+ (attachmentid == null ? 0 : attachmentid.hashCode());
		return result;
	}

	public boolean equals(Object vo) {
		if (this == vo)
			return true;
		if (!(vo instanceof CommAttachmentVO))
			return false;
		CommAttachmentVO eq = (CommAttachmentVO) vo;
		return attachmentid == null ? eq.getAttachmentid() == null
				: attachmentid.equals(eq.getAttachmentid());
	}
}