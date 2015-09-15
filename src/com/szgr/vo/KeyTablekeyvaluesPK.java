package com.szgr.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:KEY_TABLEKEYVALUES </p>
* <p>Description: KEY_TABLEKEYVALUES,Hibernate ”≥…‰VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2015-09-09 15:00:54.679
*/

public class KeyTablekeyvaluesPK implements Serializable, Cloneable {
    //Fields
    private java.lang.String taxorgcode;
    private java.lang.String keyname;
    
	//contructors
    public KeyTablekeyvaluesPK() {}

    public KeyTablekeyvaluesPK(java.lang.String taxorgcode, java.lang.String keyname) {
        this.taxorgcode = taxorgcode;    
        this.keyname = keyname;    
    }

	//methods
    public java.lang.String getTaxorgcode() {
        return this.taxorgcode;
    }

    public void setTaxorgcode(java.lang.String taxorgcode) {
        this.taxorgcode = taxorgcode;
    }

    public java.lang.String getKeyname() {
        return this.keyname;
    }

    public void setKeyname(java.lang.String keyname) {
        this.keyname = keyname;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[taxorgcode:").append(taxorgcode).append("]\n");
        sb.append("[keyname:").append(keyname).append("]\n");
        return sb.toString();
    }

    public int hashCode() {
        int result = 0;
        result = 29 * result + (taxorgcode == null ? 0 : taxorgcode.hashCode());
        result = 29 * result + (keyname == null ? 0 : keyname.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof KeyTablekeyvaluesPK))
            return false;
        KeyTablekeyvaluesPK eq = (KeyTablekeyvaluesPK)vo;
        if(taxorgcode == null ? eq.getTaxorgcode() != null : !taxorgcode.equals(eq.getTaxorgcode()))
            return false;
        if(keyname == null ? eq.getKeyname() != null : !keyname.equals(eq.getKeyname()))
            return false;
        return true;
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}