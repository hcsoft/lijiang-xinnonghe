package com.szgr.common.download;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.SocketException;

import com.szgr.framework.core.ApplicationException;
import com.szgr.util.FileUtils;

/**
 * 
 * <p>
 * Title: DownLoadClassPathFile.java
 * </p>
 * <p>
 * Description: 从类路径下下载文件
 * </p>
 * <p>
 * Copyright: Copyright (c) 2013
 * </p>
 * <p>
 * Company: szgr
 * </p>
 * 
 * @author xuhong
 * @date 2013-8-1
 * @version 1.0
 */
public class DownLoadClassPathFile implements DownloadFile {

	private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(DownLoadClassPathFile.class);
	private boolean deleteFile = false;

	public DownLoadClassPathFile(){
		
	}
	public DownLoadClassPathFile(boolean deleteFile){
		this.deleteFile = deleteFile;
	}
	
	public void download(String fileName, OutputStream os) {
		InputStream is = null;
		try {
			is = this.getClass().getClassLoader().getResourceAsStream(
					fileName);
			byte[] buffer = new byte[1024 * 1024]; // 1M;
			BufferedInputStream bis = new BufferedInputStream(is);
			BufferedOutputStream bos = new BufferedOutputStream(os);
			int len = 0;
			while ((len = bis.read(buffer)) > 0) {
                bos.write(buffer,0, len);
			}
			bos.flush();
		}catch (SocketException e) {
			
		}
		catch (IOException ex) {
			ex.printStackTrace();
            throw new ApplicationException("下载文件读取流失败！",ex);
		}
		finally{
			try {
				is.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			log.info("下载"+fileName+"至输出流"+os+"中!");
			if(isDeleteFile()){
				log.info("删除excel对象");
				FileUtils.deleteClassPathFile(fileName);
			}
		}
		
	}
	
	public boolean isDeleteFile() {
		return deleteFile;
	}

	public void setDeleteFile(boolean deleteFile) {
		this.deleteFile = deleteFile;
	}
	
}
