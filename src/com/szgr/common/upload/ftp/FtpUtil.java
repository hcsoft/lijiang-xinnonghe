package com.szgr.common.upload.ftp;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.io.IOUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;

/**
 * 
 * FTP消费类,提供一系列的FTP操作方法
 * 
 */
public class FtpUtil {

	/** 登录用户名,密码,IP等参数 */
	private String name, password, ip;

	/** 登录端口 */
	private int port;

	/** FTP操作对象 */
	private FTPClient ftpClient = null;

	/** 构造方法,初始化传入要连接的FTP参数信息 */
	public FtpUtil(FtpInfo ftpInfo) throws Exception {
		if (ftpInfo == null) {
			/** 判断如果为null 就抛出初始化异常 */
			throw new Exception("传递的FTP连接参数对象是null");
		} else {
			this.init(ftpInfo);
		}
	}

	/**
	 * 下载文件到本地
	 * 
	 * @param remoteFileName
	 * @param localFileName
	 */
	public void loadFile(String remoteFileName, String localFileName) {
		BufferedOutputStream buffOut = null;
		try {
			buffOut = new BufferedOutputStream(new FileOutputStream(
					localFileName));
			/** 写入本地文件 */
			ftpClient.retrieveFile(remoteFileName, buffOut);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (buffOut != null)
					buffOut.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 上传文件到FTP服务器上
	 * 
	 * @param localFileStream
	 * @param fileName
	 * @return
	 * @throws IOException
	 */
	public boolean uploadFile(InputStream localFileStream, String dir, String fileName)
			throws IOException {
//		System.out.println("===============" + fileName);
		/** 返回参数 */
		boolean fla = false;
		try {
			/** 设置文件类型 */
			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
			ftpClient.changeWorkingDirectory(dir);
			/** 上传之前先给文件命明为.TMP */
			String tempName = fileName + ".tmp";
			/** 开始上传文件 */
			ftpClient.storeFile(tempName, localFileStream);
			/** 上传完毕之后再该为原名 */
			renameFile(tempName, fileName);
			fla = true;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			localFileStream.close();
		}
		return fla;
	}

	/**
	 * 下载文件流
	 * 
	 * @param remoteFileName
	 * @param output
	 * @return
	 */
	public boolean downloadFile(String remoteFileName, OutputStream output)
			throws IOException {
		try {
			if ((remoteFileName != null) && (output != null)) {
				ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
				boolean ret = ftpClient.retrieveFile(remoteFileName, output);
				return ret;
			} else {
				return false;
			}
		} catch (IOException e) {
			if (e.getMessage() == "IOException caught while copying."
					|| output == null) {
				ftpClient.disconnect();
			}
			return false;
		}
	}

	/**
	 * 重命名FTP上的文件
	 * 
	 * @param oldName
	 * @param newName
	 */
	public void renameFile(String oldName, String newName) {
		try {
			/** 重命名 */
			ftpClient.rename(oldName, newName);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * 获取服务器上的文件大小
	 * 
	 * @param fileName
	 * @return
	 */
	public long getFileSizeLong(String fileName) {
		try {
			StringBuffer command = new StringBuffer("size ");
			command.append(fileName);
			ftpClient.sendCommand(command.toString());
			if (ftpClient.getReplyCode() == 213) {
				String replyText = ftpClient.getReplyString().substring(4)
						.trim();
				return Long.parseLong(replyText);
			} else {
				return 0;
			}
		} catch (Throwable e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * 获取服务器上的文件大小
	 * 
	 * @param fileName
	 * @return
	 */
	public int getFileSize(String fileName) {
		try {
			StringBuffer command = new StringBuffer("size ");
			command.append(fileName);
			ftpClient.sendCommand(command.toString());
			if (ftpClient.getReplyCode() == 213) {
				String replyText = ftpClient.getReplyString().substring(4)
						.trim();
				return Integer.parseInt(replyText);
			} else {
				return 0;
			}
		} catch (Throwable e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	/**
	 * 初始化FTP连接参数
	 * 
	 * @param ftpInfo
	 */
	public void init(FtpInfo ftpInfo) {
		this.name = ftpInfo.getName();
		this.password = ftpInfo.getPassword();
		this.ip = ftpInfo.getIp();
		this.port = ftpInfo.getPort();
		
		try {
			ftpClient = new FTPClient();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 连接到FTP服务器
	 * 
	 */
	public void connectServer() {
		try {
			ftpClient.setControlEncoding("GBK"); 
			FTPClientConfig ftpConfig = new FTPClientConfig(FTPClientConfig.SYST_NT); 
			ftpConfig.setServerLanguageCode("zh");  
//            ftpConfig.setServerLanguageCode(FTP.DEFAULT_CONTROL_ENCODING); 
			/** 如果ftpClient对象为null就实例化一个新的 */
			if (!this.ftpClient.isConnected()) {
				this.ftpClient.configure(ftpConfig);
				this.ftpClient.setControlEncoding("gbk");
				this.ftpClient.setDefaultPort(this.port);
				/** 设置默认的IP地址 */
				this.ftpClient.connect(this.ip);
				/** 连接到FTP服务器 */
				/** 登录到这台FTP服务器 */
				if (!ftpClient.login(this.name, this.password)) {
					System.out.println("服务器" + this.ip + "的用户"
							+ this.name + "登录失败!");
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	public void deleteFile(String filepath) {
		try {
			ftpClient.deleteFile(filepath);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 创建目录
	 * @return
	 */
	public boolean makedir(String... dirpath) {
		try {
			StringBuilder path = new StringBuilder();
			for (int i= 0; i< dirpath.length; i++) {
//				System.out.println("===========" + dirpath[i] + "==============");
				ftpClient.makeDirectory(dirpath[i]);
	            ftpClient.changeWorkingDirectory(dirpath[i]);
			}
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		return true;
		
	}
	
	/**
	 * 获取Ftp客户端
	 * @return
	 */
	public FTPClient getFtpClient() {
		connectServer();
		return ftpClient;
	}
	
	/**
	 * 获取Ftp客户端
	 * @return
	 */
	public FTPClient getFtpClientNotConn() {
		return ftpClient;
	}
	
	/**
	 * 销毁FTP服务器连接
	 * 
	 */
	public void closeConnect() {
		/** 判断当前ftpClient对象不为null和FTP已经被连接就关闭 */
		try {
			if (this.ftpClient.isConnected()) {
				this.ftpClient.disconnect();
			}
			/** 销毁FTP连接 */
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	   public static void main(String[] args) { 
	        FTPClient ftpClient = new FTPClient(); 
	        FileInputStream fis = null; 

	        try { 
	        	System.out.println("11111111111111");
	            ftpClient.connect("192.168.1.222"); 
	            ftpClient.login("jnds", "123456"); 
//	            ftpClient.makeDirectory("pic");
//	            ftpClient.changeWorkingDirectory("pic");
//	            ftpClient.makeDirectory("111");
//	            ftpClient.changeWorkingDirectory("111");
//	            ftpClient.makeDirectory("222");
//	            ftpClient.changeWorkingDirectory("222");

	                FileInputStream in=new FileInputStream(new File("D:/6.jpg"));  
	                boolean flag = uploadFile("192.168.1.222", 21, "jnds", "123456", "D:/ftp/pic", "ccc.jpg", in);  
	                System.out.println(flag);  

	            System.out.println("222222222");
	        } catch (IOException e) { 
	            e.printStackTrace(); 
	            throw new RuntimeException("FTP客户端出错！", e); 
	        } finally { 
	            IOUtils.closeQuietly(fis); 
	            try { 
	                ftpClient.disconnect(); 
	            } catch (IOException e) { 
	                e.printStackTrace(); 
	                throw new RuntimeException("关闭FTP连接发生异常！", e); 
	            } 
	        } 
	    } 
	   
	   public static boolean uploadFile(String url,int port,String username, String password, String path, String filename, InputStream input) {  
		    boolean success = false;  
		    FTPClient ftp = new FTPClient();  
		    try {  
		        int reply;  
		        ftp.connect(url, port);//连接FTP服务器  
		        //如果采用默认端口，可以使用ftp.connect(url)的方式直接连接FTP服务器  
		        ftp.login(username, password);//登录  
		        reply = ftp.getReplyCode();  
		        ftp.changeWorkingDirectory("pic/05");  
		        System.out.println(filename);
		        ftp.storeFile("fff.jpg", input);           
		          
		        input.close();  
		        ftp.logout();  
		        success = true;  
		    } catch (IOException e) {  
		        e.printStackTrace();  
		    } finally {  
		        if (ftp.isConnected()) {  
		            try {  
		                ftp.disconnect();  
		            } catch (IOException ioe) {  
		            }  
		        }  
		    }  
		    return success;  
		}
}
