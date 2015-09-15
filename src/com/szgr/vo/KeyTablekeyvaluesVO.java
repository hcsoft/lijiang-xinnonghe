package com.szgr.vo;

//imports
import java.lang.StringBuffer;
import java.lang.Integer;
import java.math.BigDecimal;
import java.lang.String;
import java.util.Date;
import java.io.Serializable;

/**
* <p>Title:KEY_TABLEKEYVALUES </p>
* <p>Description: KEY_TABLEKEYVALUES,Hibernate Ó³ÉäVO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2015-09-09 15:00:54.679
*/

public class KeyTablekeyvaluesVO implements Serializable, Cloneable {
    //Fields
    //formatpro
    private java.lang.String formatpro;
    //maxvalue
    private java.math.BigDecimal maxvalue;
    //datalength
    private java.lang.Integer datalength;
    //last_frtime
    private java.util.Date last_frtime;
    
    private int muteFlag;
    //¸´ºÏÖ÷¼ü
    private KeyTablekeyvaluesPK keyTablekeyvaluesPK;
    
	//contructors
    public KeyTablekeyvaluesVO() {
        this.keyTablekeyvaluesPK = new KeyTablekeyvaluesPK();
    }

    public KeyTablekeyvaluesVO(KeyTablekeyvaluesPK keyTablekeyvaluesPK) {
        this.keyTablekeyvaluesPK = keyTablekeyvaluesPK;
    }

	//methods
    public void setPrimaryKey(KeyTablekeyvaluesPK keyTablekeyvaluesPK) {
        this.keyTablekeyvaluesPK = keyTablekeyvaluesPK;
    }

    public KeyTablekeyvaluesPK getPrimaryKey() {
        return keyTablekeyvaluesPK;
    }

    public java.lang.String getFormatpro() {
        return this.formatpro;
    }

    public void setFormatpro(java.lang.String formatpro) {
        this.formatpro = formatpro;
    }

    public java.math.BigDecimal getMaxvalue() {
        return this.maxvalue;
    }

    public void setMaxvalue(java.math.BigDecimal maxvalue) {
        this.maxvalue = maxvalue;
    }

    public java.lang.Integer getDatalength() {
        return this.datalength;
    }

    public void setDatalength(java.lang.Integer datalength) {
        this.datalength = datalength;
    }

    public java.util.Date getLast_frtime() {
        return this.last_frtime;
    }

    public void setLast_frtime(java.util.Date last_frtime) {
        this.last_frtime = last_frtime;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[KeyTablekeyvaluesPK|").append(keyTablekeyvaluesPK.toString()).append("]\n");
        sb.append("[formatpro:").append(formatpro).append("]");
        sb.append("[maxvalue:").append(maxvalue).append("]");
        sb.append("[datalength:").append(datalength).append("]");
        sb.append("[last_frtime:").append(last_frtime).append("]");
        return sb.toString();
    }

    public int hashCode() {
        int result = 0;
        result = keyTablekeyvaluesPK.hashCode();
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof KeyTablekeyvaluesVO))
            return false;
        KeyTablekeyvaluesVO eq = (KeyTablekeyvaluesVO)vo;
        return keyTablekeyvaluesPK.equals(eq.getPrimaryKey());
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}