package com.szgr.common.download;

import java.io.OutputStream;

public interface DownloadFile {
	/**
	 * 下载文件
	 * @param fileName
	 */
	public void download(String fileName,OutputStream os);
    
	/**
	 * 下载文件后是否删除此文件
	 * @return
	 */
    public boolean isDeleteFile();
}
