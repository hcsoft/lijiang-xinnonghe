package com.szgr.framework.authority.vo;

//imports
import java.lang.StringBuffer;
import java.lang.String;
import java.io.Serializable;

/**
* <p>Title:用户所属组 </p>
* <p>Description: 用户所属组,Hibernate 映射VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2013-04-22 16:43:06.328
*/

public class SystemUsergroupsVO implements Serializable {
    //Fields
    //组ID
    private String group_id;
    //组名称
    private String group_code;
    //组描述
    private String group_describe;
    //组类型
    private String group_type;
    //组是否可用
    private String enabled;
    
    private int muteFlag;
    
	//contructors
    public SystemUsergroupsVO() {}

    public SystemUsergroupsVO(String group_id) {
        this.group_id = group_id;
    }

	//methods
    public String getGroup_id() {
        return this.group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getGroup_code() {
        return this.group_code;
    }

    public void setGroup_code(String group_code) {
        this.group_code = group_code;
    }

    public String getGroup_describe() {
        return this.group_describe;
    }

    public void setGroup_describe(String group_describe) {
        this.group_describe = group_describe;
    }

    public String getGroup_type() {
        return this.group_type;
    }

    public void setGroup_type(String group_type) {
        this.group_type = group_type;
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
        sb.append("[group_code:").append(group_code).append("]");
        sb.append("[group_describe:").append(group_describe).append("]");
        sb.append("[group_type:").append(group_type).append("]");
        sb.append("[enabled:").append(enabled).append("]");
        return sb.toString();
    }

    public int hashCode(){
        int result = 0;
        result = 29*result +(group_id==null ? 0 : group_id.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof SystemUsergroupsVO))
            return false;
        SystemUsergroupsVO eq = (SystemUsergroupsVO)vo;
        return group_id == null ? eq.getGroup_id() == null : group_id.equals(eq.getGroup_id());
    }
}