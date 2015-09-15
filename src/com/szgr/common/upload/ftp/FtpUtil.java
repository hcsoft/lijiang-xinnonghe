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
 * FTP������,�ṩһϵ�е�FTP��������
 * 
 */
public class FtpUtil {

	/** ��¼�û���,����,IP�Ȳ��� */
	private String name, password, ip;

	/** ��¼�˿� */
	private int port;

	/** FTP�������� */
	private FTPClient ftpClient = null;

	/** ���췽��,��ʼ������Ҫ���ӵ�FTP������Ϣ */
	public FtpUtil(FtpInfo ftpInfo) throws Exception {
		if (ftpInfo == null) {
			/** �ж����Ϊnull ���׳���ʼ���쳣 */
			throw new Exception("���ݵ�FTP���Ӳ���������null");
		} else {
			this.init(ftpInfo);
		}
	}

	/**
	 * �����ļ�������
	 * 
	 * @param remoteFileName
	 * @param localFileName
	 */
	public void loadFile(String remoteFileName, String localFileName) {
		BufferedOutputStream buffOut = null;
		try {
			buffOut = new BufferedOutputStream(new FileOutputStream(
					localFileName));
			/** д�뱾���ļ� */
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
	 * �ϴ��ļ���FTP��������
	 * 
	 * @param localFileStream
	 * @param fileName
	 * @return
	 * @throws IOException
	 */
	public boolean uploadFile(InputStream localFileStream, String dir, String fileName)
			throws IOException {
//		System.out.println("===============" + fileName);
		/** ���ز��� */
		boolean fla = false;
		try {
			/** �����ļ����� */
			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
			ftpClient.changeWorkingDirectory(dir);
			/** �ϴ�֮ǰ�ȸ��ļ�����Ϊ.TMP */
			String tempName = fileName + ".tmp";
			/** ��ʼ�ϴ��ļ� */
			ftpClient.storeFile(tempName, localFileStream);
			/** �ϴ����֮���ٸ�Ϊԭ�� */
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
	 * �����ļ���
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
	 * ������FTP�ϵ��ļ�
	 * 
	 * @param oldName
	 * @param newName
	 */
	public void renameFile(String oldName, String newName) {
		try {
			/** ������ */
			ftpClient.rename(oldName, newName);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * ��ȡ�������ϵ��ļ���С
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
	 * ��ȡ�������ϵ��ļ���С
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
	 * ��ʼ��FTP���Ӳ���
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
	 * ���ӵ�FTP������
	 * 
	 */
	public void connectServer() {
		try {
			ftpClient.setControlEncoding("GBK"); 
			FTPClientConfig ftpConfig = new FTPClientConfig(FTPClientConfig.SYST_NT); 
			ftpConfig.setServerLanguageCode("zh");  
//            ftpConfig.setServerLanguageCode(FTP.DEFAULT_CONTROL_ENCODING); 
			/** ���ftpClient����Ϊnull��ʵ����һ���µ� */
			if (!this.ftpClient.isConnected()) {
				this.ftpClient.configure(ftpConfig);
				this.ftpClient.setControlEncoding("gbk");
				this.ftpClient.setDefaultPort(this.port);
				/** ����Ĭ�ϵ�IP��ַ */
				this.ftpClient.connect(this.ip);
				/** ���ӵ�FTP������ */
				/** ��¼����̨FTP������ */
				if (!ftpClient.login(this.name, this.password)) {
					System.out.println("������" + this.ip + "���û�"
							+ this.name + "��¼ʧ��!");
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
	 * ����Ŀ¼
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
	 * ��ȡFtp�ͻ���
	 * @return
	 */
	public FTPClient getFtpClient() {
		connectServer();
		return ftpClient;
	}
	
	/**
	 * ��ȡFtp�ͻ���
	 * @return
	 */
	public FTPClient getFtpClientNotConn() {
		return ftpClient;
	}
	
	/**
	 * ����FTP����������
	 * 
	 */
	public void closeConnect() {
		/** �жϵ�ǰftpClient����Ϊnull��FTP�Ѿ������Ӿ͹ر� */
		try {
			if (this.ftpClient.isConnected()) {
				this.ftpClient.disconnect();
			}
			/** ����FTP���� */
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
	            throw new RuntimeException("FTP�ͻ��˳���", e); 
	        } finally { 
	            IOUtils.closeQuietly(fis); 
	            try { 
	                ftpClient.disconnect(); 
	            } catch (IOException e) { 
	                e.printStackTrace(); 
	                throw new RuntimeException("�ر�FTP���ӷ����쳣��", e); 
	            } 
	        } 
	    } 
	   
	   public static boolean uploadFile(String url,int port,String username, String password, String path, String filename, InputStream input) {  
		    boolean success = false;  
		    FTPClient ftp = new FTPClient();  
		    try {  
		        int reply;  
		        ftp.connect(url, port);//����FTP������  
		        //�������Ĭ�϶˿ڣ�����ʹ��ftp.connect(url)�ķ�ʽֱ������FTP������  
		        ftp.login(username, password);//��¼  
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
