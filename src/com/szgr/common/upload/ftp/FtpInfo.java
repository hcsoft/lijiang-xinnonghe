package com.szgr.common.upload.ftp;

/**
 * FTP���Ӳ���VO�� 
 */
public class FtpInfo {
	/** ��¼�û��� */
	private String name;

	/** ��¼���� */
	private String password;

	/** ��¼IP��ַ */
	private String ip;

	/** ��¼�˿� */
	private int port;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}
}