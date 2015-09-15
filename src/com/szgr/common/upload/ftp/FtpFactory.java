package com.szgr.common.upload.ftp;


public class FtpFactory {

	/**
	 * 创建一个FtpUtil的实例化对象
	 * 
	 * @param ftpInfo
	 * @return
	 */
	public FtpUtil createFtpUtil(FtpInfo ftpInfo) {
		/** 获取存储对象的实例 */
		FtpConnectMap ftpMap = FtpConnectMap.getInstance();
		/** 从HashMap中获取一个连接的实例化对象 */
		FtpUtil ftpUtil = ftpMap.getFtpUtil(ftpInfo.getName());
		if (ftpUtil == null) {
			try {
				/** 该连接不存在于HashMap中,实例化一个连接将此连接添加到HashMap中 */
				ftpUtil = new FtpUtil(ftpInfo);
				/** 实例化一个FTP连接 */
				ftpUtil.connectServer();
				ftpMap.addFtpUtil(ftpInfo.getName(), ftpUtil);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return ftpUtil;
	}
}