package com.szgr.framework.authority.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:系统用户信息(外网) </p>
* <p>Description: 系统用户信息(外网),Hibernate 映射VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2013-04-22 16:43:06.328
*/

public class SystemUsersVO implements Serializable {
    //Fields
    //用户ID
    private String user_id;
    //用户名称
    private String user_code;
    //用户密码
    private String password;
    //用户类型
    private String user_type;
    //用户描述
    private String user_describe;
    //是否可用
    private String enabled;
    //所属机构ID
    private String group_id;
    //用户详细信息ID
    private String user_detail_info_id;
    
    private int muteFlag;
    
	//contructors
    public SystemUsersVO() {}

    public SystemUsersVO(String user_id) {
        this.user_id = user_id;
    }

	//methods
    public String getUser_id() {
        return this.user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getUser_code() {
        return this.user_code;
    }

    public void setUser_code(String user_code) {
        this.user_code = user_code;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUser_type() {
        return this.user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public String getUser_describe() {
        return this.user_describe;
    }

    public void setUser_describe(String user_describe) {
        this.user_describe = user_describe;
    }

    public String getEnabled() {
        return this.enabled;
    }

    public void setEnabled(String enabled) {
        this.enabled = enabled;
    }

    public String getGroup_id() {
        return this.group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getUser_detail_info_id() {
        return this.user_detail_info_id;
    }

    public void setUser_detail_info_id(String user_detail_info_id) {
        this.user_detail_info_id = user_detail_info_id;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[user_code:").append(user_code).append("]");
        sb.append("[password:").append(password).append("]");
        sb.append("[user_type:").append(user_type).append("]");
        sb.append("[user_describe:").append(user_describe).append("]");
        sb.append("[enabled:").append(enabled).append("]");
        sb.append("[group_id:").append(group_id).append("]");
        sb.append("[user_detail_info_id:").append(user_detail_info_id).append("]");
        return sb.toString();
    }

    public int hashCode(){
        int result = 0;
        result = 29*result +(user_id==null ? 0 : user_id.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof SystemUsersVO))
            return false;
        SystemUsersVO eq = (SystemUsersVO)vo;
        return user_id == null ? eq.getUser_id() == null : user_id.equals(eq.getUser_id());
    }
}