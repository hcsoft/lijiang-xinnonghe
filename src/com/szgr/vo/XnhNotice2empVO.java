package com.szgr.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:xnh_notice2emp </p>
* <p>Description: xnh_notice2emp,Hibernate ”≥…‰VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2015-10-06 09:50:11.668
*/

public class XnhNotice2empVO implements Serializable, Cloneable {
    //Fields
    //serialno
    private java.lang.String serialno;
    //noticeid
    private java.lang.String noticeid;
    //empcode
    private java.lang.String empcode;
    //readflag
    private java.lang.String readflag;
    
    private int muteFlag;
    
	//contructors
    public XnhNotice2empVO() {}

    public XnhNotice2empVO(java.lang.String serialno) {
        this.serialno = serialno;
    }

	//methods
    public java.lang.String getSerialno() {
        return this.serialno;
    }

    public void setSerialno(java.lang.String serialno) {
        this.serialno = serialno;
    }

    public java.lang.String getNoticeid() {
        return this.noticeid;
    }

    public void setNoticeid(java.lang.String noticeid) {
        this.noticeid = noticeid;
    }

    public java.lang.String getEmpcode() {
        return this.empcode;
    }

    public void setEmpcode(java.lang.String empcode) {
        this.empcode = empcode;
    }

    public java.lang.String getReadflag() {
        return this.readflag;
    }

    public void setReadflag(java.lang.String readflag) {
        this.readflag = readflag;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[noticeid:").append(noticeid).append("]");
        sb.append("[empcode:").append(empcode).append("]");
        sb.append("[readflag:").append(readflag).append("]");
        return sb.toString();
    }

    public int hashCode() {
        int result = 0;
        result = 29 * result + (serialno == null ? 0 : serialno.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof XnhNotice2empVO))
            return false;
        XnhNotice2empVO eq = (XnhNotice2empVO)vo;
        return serialno == null ? eq.getSerialno() == null : serialno.equals(eq.getSerialno());
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}