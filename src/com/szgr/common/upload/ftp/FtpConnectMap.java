package com.szgr.common.upload.ftp;

import java.util.HashMap;

/**
 * ����һ��HashMap,װ��FTP���ӵ�ʵ��������,������FTP�����ӳ�ʹ��
 * 
 * @author ThinkPad
 * 
 */
public class FtpConnectMap {
	private static HashMap connectMap = new HashMap();

	private static FtpConnectMap ftpMap = null;

	/**
	 * ���FtpConnectMap��ʵ��������
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
	 * ͨ��Name��ȡ����HashMap�е�FTP���Ӷ���
	 * 
	 * @param name
	 * @return
	 */
	public FtpUtil getFtpUtil(String name) {
		FtpUtil ftpUtil = (FtpUtil) connectMap.get(name);
		return ftpUtil;
	}

	/**
	 * ��HashMap���һ���µ�FTP���Ӷ���
	 * 
	 * @param name
	 * @param ftpUtil
	 */
	public void addFtpUtil(String name, FtpUtil ftpUtil) {
		connectMap.put(name, ftpUtil);
	}

}
