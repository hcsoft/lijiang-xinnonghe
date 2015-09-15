package com.szgr.framework.authority.services.Authority.bo;

import java.io.Serializable;

/**
 * url与角色关联BO
 *
 */
public class Url2RoleBO implements Serializable{

	private String url;
	private String roleStr;
	public Url2RoleBO(){
		
	}
	public Url2RoleBO(String url,String roleStr){
		this.url=url;
		this.roleStr = roleStr;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getRoleStr() {
		return roleStr;
	}
	public void setRoleStr(String roleStr) {
		this.roleStr = roleStr;
	}
	
}
