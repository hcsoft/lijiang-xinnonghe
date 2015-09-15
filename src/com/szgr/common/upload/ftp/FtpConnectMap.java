package com.szgr.common.upload.ftp;

import java.util.HashMap;

/**
 * 定义一个HashMap,装载FTP连接的实例化对象,这里做FTP的连接池使用
 * 
 * @author ThinkPad
 * 
 */
public class FtpConnectMap {
	private static HashMap connectMap = new HashMap();

	private static FtpConnectMap ftpMap = null;

	/**
	 * 获得FtpConnectMap的实例化对象
	 * 
	 * @return
	 */
	public static FtpConnectMap getInstance() {
		if (ftpMap == null) {
			ftpMap = new FtpConnectMap();
		}
		return ftpMap;
	}

	/**
	 * 通过Name获取存在HashMap中的FTP连接对象
	 * 
	 * @param name
	 * @return
	 */
	public FtpUtil getFtpUtil(String name) {
		FtpUtil ftpUtil = (FtpUtil) connectMap.get(name);
		return ftpUtil;
	}

	/**
	 * 给HashMap添加一个新的FTP连接对象
	 * 
	 * @param name
	 * @param ftpUtil
	 */
	public void addFtpUtil(String name, FtpUtil ftpUtil) {
		connectMap.put(name, ftpUtil);
	}

}
