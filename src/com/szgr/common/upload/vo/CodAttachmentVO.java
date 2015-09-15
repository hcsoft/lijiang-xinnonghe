package com.szgr.common.upload.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:COD_ATTACHMENT </p>
* <p>Description: COD_ATTACHMENT,Hibernate ”≥…‰VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2013-05-29 17:06:35.528
*/

public class CodAttachmentVO implements Serializable {
    //Fields
    //attachmentcode
    private java.lang.String attachmentcode;
    //attachmentname
    private java.lang.String attachmentname;
    //node
    private java.lang.String node;
    //valid
    private java.lang.String valid;
    
    private int muteFlag;
    
	//contructors
    public CodAttachmentVO() {}

    public CodAttachmentVO(java.lang.String attachmentcode) {
        this.attachmentcode = attachmentcode;
    }

	//methods
    public java.lang.String getAttachmentcode() {
        return this.attachmentcode;
    }

    public void setAttachmentcode(java.lang.String attachmentcode) {
        this.attachmentcode = attachmentcode;
    }

    public java.lang.String getAttachmentname() {
        return this.attachmentname;
    }

    public void setAttachmentname(java.lang.String attachmentname) {
        this.attachmentname = attachmentname;
    }

    public java.lang.String getNode() {
        return this.node;
    }

    public void setNode(java.lang.String node) {
        this.node = node;
    }

    public java.lang.String getValid() {
        return this.valid;
    }

    public void setValid(java.lang.String valid) {
        this.valid = valid;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[attachmentname:").append(attachmentname).append("]");
        sb.append("[node:").append(node).append("]");
        sb.append("[valid:").append(valid).append("]");
        return sb.toString();
    }

    public int hashCode(){
        int result = 0;
        result = 29*result +(attachmentcode==null ? 0 : attachmentcode.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof CodAttachmentVO))
            return false;
        CodAttachmentVO eq = (CodAttachmentVO)vo;
        return attachmentcode == null ? eq.getAttachmentcode() == null : attachmentcode.equals(eq.getAttachmentcode());
    }
}