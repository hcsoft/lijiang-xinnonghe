package com.szgr.framework.authority.services.Authority.bo;

import java.io.Serializable;

/**
 * 用户Id或者组Id与资源关联BO
 *
 */
public class UrlCheckBO implements Serializable{

	/**
	 * 是否通过验证当前用户有没有直接关联的资源
	 */
	private boolean isAccessUserId;
	/**
	 * 用户ID或者组ID
	 */
	private String id;
	/**
	 * 当前访问的资源（url）
	 */
	private String url;
	
	/**
	 *返回信息（判断用户是否具有对当前资源的访问权限） 
	 */
	private boolean isAccess;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public boolean isAccessUserId() {
		return isAccessUserId;
	}
	public void setAccessUserId(boolean isAccessUserId) {
		this.isAccessUserId = isAccessUserId;
	}
	public boolean isAccess() {
		return isAccess;
	}
	public void setAccess(boolean isAccess) {
		this.isAccess = isAccess;
	}
	
}
