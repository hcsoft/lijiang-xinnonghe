package com.szgr.framework.authority.services.Authority.bo;

import java.io.Serializable;

/**
 * �û�Id������Id����Դ����BO
 *
 */
public class UrlCheckBO implements Serializable{

	/**
	 * �Ƿ�ͨ����֤��ǰ�û���û��ֱ�ӹ�������Դ
	 */
	private boolean isAccessUserId;
	/**
	 * �û�ID������ID
	 */
	private String id;
	/**
	 * ��ǰ���ʵ���Դ��url��
	 */
	private String url;
	
	/**
	 *������Ϣ���ж��û��Ƿ���жԵ�ǰ��Դ�ķ���Ȩ�ޣ� 
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
