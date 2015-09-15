package com.szgr.common.upload.vo;

//imports
import java.lang.StringBuffer;
import java.lang.Integer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:BAS_BUSINESSATTACHMENT </p>
* <p>Description: BAS_BUSINESSATTACHMENT,Hibernate ”≥…‰VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2013-05-29 17:06:35.528
*/

public class BasBusinessattachmentVO implements Serializable {
    //Fields
    //businessattachmentid
    private java.lang.String businessattachmentid;
    //businesscode
    private java.lang.String businesscode;
    //attachmentcode
    private java.lang.String attachmentcode;
    //isdefault
    private java.lang.Integer isdefault;
    
    private int muteFlag;
    
	//contructors
    public BasBusinessattachmentVO() {}

    public BasBusinessattachmentVO(java.lang.String businessattachmentid) {
        this.businessattachmentid = businessattachmentid;
    }

	//methods
    public java.lang.String getBusinessattachmentid() {
        return this.businessattachmentid;
    }

    public void setBusinessattachmentid(java.lang.String businessattachmentid) {
        this.businessattachmentid = businessattachmentid;
    }

    public java.lang.String getBusinesscode() {
        return this.businesscode;
    }

    public void setBusinesscode(java.lang.String businesscode) {
        this.businesscode = businesscode;
    }

    public java.lang.String getAttachmentcode() {
        return this.attachmentcode;
    }

    public void setAttachmentcode(java.lang.String attachmentcode) {
        this.attachmentcode = attachmentcode;
    }

    public java.lang.Integer getIsdefault() {
        return this.isdefault;
    }

    public void setIsdefault(java.lang.Integer isdefault) {
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
        sb.append("[attachmentcode:").append(attachmentcode).append("]");
        sb.append("[isdefault:").append(isdefault).append("]");
        return sb.toString();
    }

    public int hashCode(){
        int result = 0;
        result = 29*result +(businessattachmentid==null ? 0 : businessattachmentid.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof BasBusinessattachmentVO))
            return false;
        BasBusinessattachmentVO eq = (BasBusinessattachmentVO)vo;
        return businessattachmentid == null ? eq.getBusinessattachmentid() == null : businessattachmentid.equals(eq.getBusinessattachmentid());
    }
}