package com.szgr.common.download;

import java.io.OutputStream;

public interface DownloadFile {
	/**
	 * �����ļ�
	 * @param fileName
	 */
	public void download(String fileName,OutputStream os);
    
	/**
	 * �����ļ����Ƿ�ɾ�����ļ�
	 * @return
	 */
    public boolean isDeleteFile();
}
