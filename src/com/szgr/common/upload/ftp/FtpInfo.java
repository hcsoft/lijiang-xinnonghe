package com.szgr.common.upload.ftp;

/**
 * FTP连接参数VO类 
 */
public class FtpInfo {
	/** 登录用户名 */
	private String name;

	/** 登录密码 */
	private String password;

	/** 登录IP地址 */
	private String ip;

	/** 登录端口 */
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