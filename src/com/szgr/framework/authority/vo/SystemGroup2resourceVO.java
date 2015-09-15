package com.szgr.framework.authority.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:组与资源关联 </p>
* <p>Description: 组与资源关联,Hibernate 映射VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2013-04-22 16:43:06.328
*/

public class SystemGroup2resourceVO implements Serializable {
    //Fields
    //序列号
    private String serial_id;
    //机构ID
    private String group_id;
    //资源ID
    private String resource_id;
    
    private int muteFlag;
    
	//contructors
    public SystemGroup2resourceVO() {}

    public SystemGroup2resourceVO(String serial_id) {
        this.serial_id = serial_id;
    }

	//methods
    public String getSerial_id() {
        return this.serial_id;
    }

    public void setSerial_id(String serial_id) {
        this.serial_id = serial_id;
    }

    public String getGroup_id() {
        return this.group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getResource_id() {
        return this.resource_id;
    }

    public void setResource_id(String resource_id) {
        this.resource_id = resource_id;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[group_id:").append(group_id).append("]");
        sb.append("[resource_id:").append(resource_id).append("]");
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
        if(!(vo instanceof SystemGroup2resourceVO))
            return false;
        SystemGroup2resourceVO eq = (SystemGroup2resourceVO)vo;
        return serial_id == null ? eq.getSerial_id() == null : serial_id.equals(eq.getSerial_id());
    }
}