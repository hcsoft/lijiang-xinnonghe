package com.szgr.common.upload.ftp;


public class FtpFactory {

	/**
	 * ����һ��FtpUtil��ʵ��������
	 * 
	 * @param ftpInfo
	 * @return
	 */
	public FtpUtil createFtpUtil(FtpInfo ftpInfo) {
		/** ��ȡ�洢�����ʵ�� */
		FtpConnectMap ftpMap = FtpConnectMap.getInstance();
		/** ��HashMap�л�ȡһ�����ӵ�ʵ�������� */
		FtpUtil ftpUtil = ftpMap.getFtpUtil(ftpInfo.getName());
		if (ftpUtil == null) {
			try {
				/** �����Ӳ�������HashMap��,ʵ����һ�����ӽ���������ӵ�HashMap�� */
				ftpUtil = new FtpUtil(ftpInfo);
				/** ʵ����һ��FTP���� */
				ftpUtil.connectServer();
				ftpMap.addFtpUtil(ftpInfo.getName(), ftpUtil);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return ftpUtil;
	}
}