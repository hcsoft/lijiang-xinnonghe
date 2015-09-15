package com.szgr.framework.authority.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:系统权限角色 </p>
* <p>Description: 系统权限角色,Hibernate 映射VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2013-04-22 16:43:06.328
*/

public class SystemRolesVO implements Serializable {
    //Fields
    //角色ID
    private String role_id;
    //角色名称
    private String role_code;
    //角色描述
    private String role_describe;
    //角色是否可用
    private String enabled;
    
    private int muteFlag;
    
	//contructors
    public SystemRolesVO() {}

    public SystemRolesVO(String role_id) {
        this.role_id = role_id;
    }

	//methods
    public String getRole_id() {
        return this.role_id;
    }

    public void setRole_id(String role_id) {
        this.role_id = role_id;
    }

    public String getRole_code() {
        return this.role_code;
    }

    public void setRole_code(String role_code) {
        this.role_code = role_code;
    }

    public String getRole_describe() {
        return this.role_describe;
    }

    public void setRole_describe(String role_describe) {
        this.role_describe = role_describe;
    }

    public String getEnabled() {
        return this.enabled;
    }

    public void setEnabled(String enabled) {
        this.enabled = enabled;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[role_code:").append(role_code).append("]");
        sb.append("[role_describe:").append(role_describe).append("]");
        sb.append("[enabled:").append(enabled).append("]");
        return sb.toString();
    }

    public int hashCode(){
        int result = 0;
        result = 29*result +(role_id==null ? 0 : role_id.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof SystemRolesVO))
            return false;
        SystemRolesVO eq = (SystemRolesVO)vo;
        return role_id == null ? eq.getRole_id() == null : role_id.equals(eq.getRole_id());
    }
}