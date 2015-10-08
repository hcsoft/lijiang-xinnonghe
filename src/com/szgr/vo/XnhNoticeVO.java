package com.szgr.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.util.Date;
import java.io.Serializable;

/**
* <p>Title:xnh_notice </p>
* <p>Description: xnh_notice,Hibernate ”≥…‰VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2015-10-06 09:50:11.668
*/

public class XnhNoticeVO implements Serializable, Cloneable {
    //Fields
    //id
    private java.lang.String id;
    //title
    private java.lang.String title;
    //content
    private java.lang.String content;
    //datebegin
    private java.util.Date datebegin;
    //dateend
    private java.util.Date dateend;
    //to_orgcode
    private java.lang.String to_orgcode;
    //opt_orgcode
    private java.lang.String opt_orgcode;
    //opt_empcode
    private java.lang.String opt_empcode;
    //optdate
    private java.util.Date optdate;
    //valid
    private java.lang.String valid;
    
    private int muteFlag;
    
	//contructors
    public XnhNoticeVO() {}

    public XnhNoticeVO(java.lang.String id) {
        this.id = id;
    }

	//methods
    public java.lang.String getId() {
        return this.id;
    }

    public void setId(java.lang.String id) {
        this.id = id;
    }

    public java.lang.String getTitle() {
        return this.title;
    }

    public void setTitle(java.lang.String title) {
        this.title = title;
    }

    public java.lang.String getContent() {
        return this.content;
    }

    public void setContent(java.lang.String content) {
        this.content = content;
    }

    public java.util.Date getDatebegin() {
        return this.datebegin;
    }

    public void setDatebegin(java.util.Date datebegin) {
        this.datebegin = datebegin;
    }

    public java.util.Date getDateend() {
        return this.dateend;
    }

    public void setDateend(java.util.Date dateend) {
        this.dateend = dateend;
    }

    public java.lang.String getTo_orgcode() {
        return this.to_orgcode;
    }

    public void setTo_orgcode(java.lang.String to_orgcode) {
        this.to_orgcode = to_orgcode;
    }

    public java.lang.String getOpt_orgcode() {
        return this.opt_orgcode;
    }

    public void setOpt_orgcode(java.lang.String opt_orgcode) {
        this.opt_orgcode = opt_orgcode;
    }

    public java.lang.String getOpt_empcode() {
        return this.opt_empcode;
    }

    public void setOpt_empcode(java.lang.String opt_empcode) {
        this.opt_empcode = opt_empcode;
    }

    public java.util.Date getOptdate() {
        return this.optdate;
    }

    public void setOptdate(java.util.Date optdate) {
        this.optdate = optdate;
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
        sb.append("[title:").append(title).append("]");
        sb.append("[content:").append(content).append("]");
        sb.append("[datebegin:").append(datebegin).append("]");
        sb.append("[dateend:").append(dateend).append("]");
        sb.append("[to_orgcode:").append(to_orgcode).append("]");
        sb.append("[opt_orgcode:").append(opt_orgcode).append("]");
        sb.append("[opt_empcode:").append(opt_empcode).append("]");
        sb.append("[optdate:").append(optdate).append("]");
        sb.append("[valid:").append(valid).append("]");
        return sb.toString();
    }

    public int hashCode() {
        int result = 0;
        result = 29 * result + (id == null ? 0 : id.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof XnhNoticeVO))
            return false;
        XnhNoticeVO eq = (XnhNoticeVO)vo;
        return id == null ? eq.getId() == null : id.equals(eq.getId());
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}