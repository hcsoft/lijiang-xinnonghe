package com.szgr.framework.authority.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:用户与组关联 </p>
* <p>Description: 用户与组关联,Hibernate 映射VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2013-04-22 16:43:06.328
*/

public class SystemUser2groupVO implements Serializable {
    //Fields
    //序列号
    private String serial_id;
    //用户ID
    private String user_id;
    //组ID
    private String group_id;
    
    private int muteFlag;
    
	//contructors
    public SystemUser2groupVO() {}

    public SystemUser2groupVO(String serial_id) {
        this.serial_id = serial_id;
    }

	//methods
    public String getSerial_id() {
        return this.serial_id;
    }

    public void setSerial_id(String serial_id) {
        this.serial_id = serial_id;
    }

    public String getUser_id() {
        return this.user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getGroup_id() {
        return this.group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[user_id:").append(user_id).append("]");
        sb.append("[group_id:").append(group_id).append("]");
        return sb.toString();
    }

    public int hashCode(){
        int result = 0;
        result = 29*result +(serial_id==null ? 0 : serial_id.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof SystemUser2groupVO))
            return false;
        SystemUser2groupVO eq = (SystemUser2groupVO)vo;
        return serial_id == null ? eq.getSerial_id() == null : serial_id.equals(eq.getSerial_id());
    }
}