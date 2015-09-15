package com.szgr.framework.authority.services.Authority.bean;

import java.util.ArrayList;
import java.util.List;

import com.szgr.framework.authority.UserInfo;
import com.szgr.framework.authority.services.Authority.bo.RoleBO;
import com.szgr.framework.authority.services.Authority.bo.Url2RoleBO;
import com.szgr.framework.authority.services.Authority.bo.UrlCheckBO;

/**
 * Ȩ�޿��Ʒ���bean

 *
 */
public class AuthorityBean {

	/**
	 * ������Ϣ
	 */
	private UserInfo userInfo;
	/**
	 * �û�Id������Id����Դ����BO
	 */
	private UrlCheckBO urlCheck;
	/**
	 * �û�Ȩ��
	 */
	private List<RoleBO> roles = new ArrayList<RoleBO>();
	/**
	 *Ȩ����Դ 
	 */
	private List<Url2RoleBO> url2Roles = new ArrayList<Url2RoleBO>();
	
	public UserInfo getUserInfo() {
		return userInfo;
	}
	public void setUserInfo(UserInfo userInfo) {
		this.userInfo = userInfo;
	}
	public List<RoleBO> getRoles() {
		return roles;
	}
	public void setRoles(List<RoleBO> roles) {
		this.roles = roles;
	}
	public List<Url2RoleBO> getUrl2Roles() {
		return url2Roles;
	}
	public void setUrl2Roles(List<Url2RoleBO> url2Roles) {
		this.url2Roles = url2Roles;
	}
	public UrlCheckBO getUrlCheck() {
		return urlCheck;
	}
	public void setUrlCheck(UrlCheckBO urlCheck) {
		this.urlCheck = urlCheck;
	}

	
	
}
