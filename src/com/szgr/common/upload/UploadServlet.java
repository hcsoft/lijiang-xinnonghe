package com.szgr.common.upload;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.imgscalr.Scalr;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.szgr.common.PropertyConfigurer.PropertyConfigurerAcesse;
import com.szgr.common.uid.UUIDGener;
import com.szgr.common.upload.ftp.FtpInfo;
import com.szgr.common.upload.ftp.FtpUtil;
import com.szgr.common.upload.vo.CommAttachmentVO;
import com.szgr.util.StringUtils;

//@Component("UploadServlet")
public class UploadServlet extends HttpServlet {
	private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(UploadServlet.class);
	private static final long MAX_SIZE = 4 * 1024 * 1024; // 4m (单次上传文件总大小)
	private static final long MAX_SINGLE_SIZE = 1 * 1024 * 1024; // 1m
	// (单个文件大小)

	@Autowired
	HibernateTemplate hibernateTemplate;
	String ftpUrl = "";
	String ftpPort = "";
	String ftpDir = "";
	String username = "";
	String password = "";

	
	public void init() throws ServletException {
		super.init();

		ServletContext servletContext = this.getServletContext();

		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(servletContext);

		hibernateTemplate = (HibernateTemplate) ctx
				.getBean("hibernateTemplate");
		ftpUrl = (String) PropertyConfigurerAcesse.getContextProperty("ftpUrl");
		ftpPort = (String) PropertyConfigurerAcesse
				.getContextProperty("ftpPort");
		ftpDir = (String) PropertyConfigurerAcesse.getContextProperty("ftpDir");
		username = (String) PropertyConfigurerAcesse
				.getContextProperty("username");
		password = (String) PropertyConfigurerAcesse
				.getContextProperty("password");
	}

	
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		if (request.getParameter("getfile") != null
				&& StringUtils.notEmpty(request.getParameter("getfile"))) {  
			try {
			String fileName = new String(request.getParameter("getfile").getBytes("iso-8859-1"), "utf-8");
			System.out.println("fileName:"+fileName);
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			FtpUtil ftpserver = getftpserver(ftpUrl, ftpPort, username,password); // 获取ftp服务
			String ftpurl  = request.getParameter("ftp_path");
			ftpserver.getFtpClientNotConn().changeWorkingDirectory(ftpurl);
			ftpserver.downloadFile(fileName, output);
			int bytes = 0;
			ServletOutputStream op = response.getOutputStream();
			response.setContentType(getMimeTypeByFileName(fileName));
			response.setContentLength(ftpserver.getFileSize(fileName));
			response.setHeader("Content-Disposition", "inline; filename=\""
					+ new String(fileName.getBytes("gb2312"), "ISO8859-1")
					+ "\"");
			byte[] bbuf = new byte[1024];
			DataInputStream in = new DataInputStream(new ByteArrayInputStream(
					output.toByteArray()));

			while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
				op.write(bbuf, 0, bytes);
			}
			in.close();
			op.flush();
			op.close();
			}catch (Exception ex){
				log.warn("读取图片文件出错!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!！");
				ex.printStackTrace();
			}
		} else if (request.getParameter("delfile") != null
				&& StringUtils.notEmpty(request.getParameter("delfile"))) {
			FtpUtil ftpserver = getftpserver(ftpUrl, ftpPort, username,
					password); // 获取ftp服务
			ftpserver.getFtpClient().changeWorkingDirectory(
					request.getParameter("ftp_path"));
			ftpserver.getFtpClientNotConn().deleteFile(
					new String(request.getParameter("delfile").getBytes(
							"iso-8859-1"), "gbk"));
			String attachmentid = request.getParameter("attachmentid");
			Session session = hibernateTemplate.getSessionFactory().openSession();
			String hql = "delete CommAttachmentVO where attachmentid=:attachmentid";
			Transaction t = null;
			try {
				t = session.beginTransaction();
				Query q = session.createQuery(hql);
				q.setParameter("attachmentid", attachmentid);
				q.executeUpdate();
				t.commit();
			} catch (Exception ex) {
				if (t != null) {
					t.rollback();
				}
			} finally {
				session.close();
			}

		} else if (request.getParameter("getthumb") != null
				&& StringUtils.notEmpty(request.getParameter("getthumb"))) {
			String fileName = new String(request.getParameter("getthumb")
					.getBytes("iso-8859-1"), "utf-8");
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			FtpUtil ftpserver = getftpserver(ftpUrl, ftpPort, username,
					password); // 获取ftp服务
			ftpserver.getFtpClientNotConn().changeWorkingDirectory(
					request.getParameter("ftp_path"));
			ftpserver.downloadFile(fileName, output);
			InputStream is = new ByteArrayInputStream(output.toByteArray());

			String mimetype = getMimeTypeByFileName(fileName);
			if (mimetype.endsWith("png") || mimetype.endsWith("jpeg")
					|| mimetype.endsWith("jpg") || mimetype.endsWith("gif")) {
				BufferedImage im = ImageIO.read(is);
				if (im != null) {
					BufferedImage thumb = Scalr.resize(im, 60);
					ByteArrayOutputStream os = new ByteArrayOutputStream();
					if (mimetype.endsWith("png")) {
						ImageIO.write(thumb, "PNG", os);
						response.setContentType("image/png");
					} else if (mimetype.endsWith("jpeg")) {
						ImageIO.write(thumb, "jpg", os);
						response.setContentType("image/jpeg");
					} else if (mimetype.endsWith("jpg")) {
						ImageIO.write(thumb, "jpg", os);
						response.setContentType("image/jpeg");
					} else {
						ImageIO.write(thumb, "GIF", os);
						response.setContentType("image/gif");
					}
					ServletOutputStream srvos = response.getOutputStream();
					response.setContentLength(os.size());
					response.setHeader("Content-Disposition",
							"inline; filename=\"" + fileName + "\"");
					os.writeTo(srvos);
					srvos.flush();
					srvos.close();
				}
			}
			is.close();
		} else if (request.getParameter("getXfile") != null
				&& StringUtils.notEmpty(request.getParameter("getXfile")) ) {
//			FtpUtil ftpserver = getftpserver(ftpUrl, ftpPort, username,
//					password); // 获取ftp服务
			String fileName = new String(request.getParameter("getXfile")
					.getBytes("iso-8859-1"), "utf-8");
			String ftpurl  ="/"+ request.getParameter("ftp_path");
//			System.out.println("ftpurl:"+ftpurl);
//			
//			ftpserver.getFtpClient().changeWorkingDirectory(ftpurl);
			
//			ftpserver.loadFile(remotefileName, fileName);
			
			FTPClient ftpClient = new FTPClient(); 
			FileOutputStream  fos = null; 

	        try { 
	        	String remoteFileName  =ftpurl+"/"+ fileName;
	            ftpClient.connect("192.168.0.110"); 
	            ftpClient.login("jnds", "123456"); 
	           
	            System.err.println(remoteFileName);
	            fos = new FileOutputStream ("c:/1.jpg"); 
	            
	            ftpClient.setBufferSize(1024); 
	            //设置文件类型（二进制） 
	            ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE); 
	            ftpClient.retrieveFile(remoteFileName, fos); 
	           
	        } catch (IOException e) { 
	            e.printStackTrace(); 
	            throw new RuntimeException("FTP客户端出错！", e); 
	        } finally { 
	            IOUtils.closeQuietly(fos); 
	            try { 
	                ftpClient.disconnect(); 
	            } catch (IOException e) { 
	                e.printStackTrace(); 
	                throw new RuntimeException("关闭FTP连接发生异常！", e); 
	            } 
	        } 
			
		
		}
		else {
			PrintWriter writer = response.getWriter();
			writer.write("call POST with multipart form data");
		}
	}

	@SuppressWarnings("unchecked")
	
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String businessCode = "";
		String businessNumber = "";
		String attachmentCode = "";
		String isDefault = "";
		String taxempcode = "";
//		Object principal = SecurityContextHolder.getContext()
//				.getAuthentication().getPrincipal();
//		if (principal instanceof UserInfo) {
//			UserInfo userInfo = (UserInfo) principal;
//			taxempcode = userInfo.getTaxempcode();
//		}
//		System.out.println("--------------" + taxempcode);
		response.setContentType("text/json;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException("非'multipart/form-data'类型数据");
		}
		ServletFileUpload uploadHandler = new ServletFileUpload(
				new DiskFileItemFactory());
		PrintWriter writer = response.getWriter();
		JSONArray json = new JSONArray();
		JSONArray json2 = new JSONArray();
		try {
			uploadHandler.setHeaderEncoding("utf-8");
			List<FileItem> items = uploadHandler.parseRequest(request);
			for (FileItem item : items) {
				if (item.isFormField()) { // 普通域,获取页面参数
					String field = item.getFieldName();
					if (field.equals("businessCode")) {
						businessCode = item.getString();
						continue;
					} else if (field.equals("businessNumber")) {
						businessNumber = item.getString();
						continue;
					} else if (field.equals("attachmentCode")) {
						attachmentCode = item.getString();
						continue;
					} else if (field.equals("isDefault")) {
						isDefault = item.getString();
						continue;
					}
				}
			}
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
			String address = format.format(new Date());
			String dir = ftpDir(ftpDir, businessCode, businessNumber);
			String[] dirs = ftpDirs(ftpDir, businessCode, businessNumber);
			FtpUtil ftpserver = getftpserver(ftpUrl, ftpPort, username,
					password); // 获取ftp服务
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(2 * 1024 * 1024); // 2M
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setSizeMax(MAX_SIZE);
			upload.setFileSizeMax(MAX_SINGLE_SIZE);
			String tmpath = request.getRealPath("/") + "/tmp";

			BufferedInputStream bis = null;
			FileOutputStream fos = null;

			File tmpdir = new File(tmpath); // 临时文件夹
			if (tmpdir.exists() == false) {
				tmpdir.mkdir();
			}

			File tmpfiledir = new File(tmpdir, tmpFilePath()); // 上传文件临时文件夹
			if (tmpfiledir.exists() == false) {
				tmpfiledir.mkdir();
			}

			for (FileItem item : items) {
				if (!item.isFormField()) {
					int filesize = (int) item.getSize();
					String filename = getfilename(item.getName());
					// File file = new File(tmpdir,filename);
					File file = new File(tmpfiledir, filename);
					if (file.exists() == false) {
						file.createNewFile();
					}
					bis = new BufferedInputStream(item.getInputStream());
					byte[] b = new byte[bis.available() + 1];
					bis.read(b);
					bis.close();

					fos = new FileOutputStream(file);
					fos.write(b);
					fos.flush();
					fos.close();
					String attachmentid = "";
					if (upftp(ftpserver, dir, dirs, filename, file.getPath())) { // 上传服务
						file.delete(); // 删除临时文件

						Session session = hibernateTemplate.getSessionFactory()
								.openSession();
						Transaction t = null;
						try {
							t = session.beginTransaction();
							CommAttachmentVO vo = new CommAttachmentVO();
							attachmentid = UUIDGener.getUUID();
							vo.setAttachmentid(attachmentid);
							vo.setBusinesscode(businessCode);
							vo.setBusinessnumber(businessNumber);
							vo.setAttachmentname(item.getName());
//							System.out.println("----------------" + attachmentCode);
							vo.setAttachmentcode(attachmentCode);
							vo.setFilesize(new BigDecimal(filesize));
							vo.setAddress(address);
							vo.setUploaddate(new Date());
							vo.setInputperson(taxempcode);
							vo.setIsdefault(isDefault);
							hibernateTemplate.save(vo);
							hibernateTemplate.flush();
							t.commit();
						} catch (Exception ex) {
							ex.printStackTrace();
							if (t != null) {
								t.rollback();
							}
						} finally {
							session.close();
						}
						JSONObject jsono = new JSONObject();
						jsono.put("name", item.getName());
						jsono.put("size", item.getSize());
						jsono.put("url", "UploadServlet?getfile="
								+ item.getName() + "&ftp_path=" + dir);
						jsono.put("thumbnail_url", "UploadServlet?getthumb="
								+ item.getName() + "&ftp_path=" + dir);
						jsono.put("delete_url", "UploadServlet?delfile="
								+ item.getName() + "&ftp_path=" + dir + "&attachmentid=" + attachmentid);
						jsono.put("delete_type", "GET");
						// jsono.put("ftp_path", dir);
						json.put(jsono);
						System.out.println(json.toString());

					}
				}
			}
			tmpfiledir.delete(); // 删除临时文件夹
			// System.out.println("-----------------" + businessCode);
			// System.out.println("-----------------" + businessNumber);

		} catch (FileUploadException e) {
			throw new RuntimeException(e);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			writer.write(json.toString());
			response.flushBuffer();
			writer.close();
		}

	}

	private String getMimeType(File file) {
		String mimetype = "";
		if (file.exists()) {
			if (getSuffix(file.getName()).equalsIgnoreCase("png")) {
				mimetype = "image/png";
			} else if (getSuffix(file.getName()).equalsIgnoreCase("jpg")) {
				mimetype = "image/jpg";
			} else if (getSuffix(file.getName()).equalsIgnoreCase("jpeg")) {
				mimetype = "image/jpeg";
			} else if (getSuffix(file.getName()).equalsIgnoreCase("gif")) {
				mimetype = "image/gif";
			} else {
				javax.activation.MimetypesFileTypeMap mtMap = new javax.activation.MimetypesFileTypeMap();
				mimetype = mtMap.getContentType(file);
			}
		}
		return mimetype;
	}

	private String getMimeTypeByFileName(String fileName) {
		String mimetype = "";
		if (getSuffix(fileName).equalsIgnoreCase("png")) {
			mimetype = "image/png";
		} else if (getSuffix(fileName).equalsIgnoreCase("jpg")) {
			mimetype = "image/jpg";
		} else if (getSuffix(fileName).equalsIgnoreCase("jpeg")) {
			mimetype = "image/jpeg";
		} else if (getSuffix(fileName).equalsIgnoreCase("gif")) {
			mimetype = "image/gif";
		} else {
			// javax.activation.MimetypesFileTypeMap mtMap = new
			// javax.activation.MimetypesFileTypeMap();
			// mimetype = mtMap.getContentType(file);
		}
		return mimetype;
	}

	private String getSuffix(String filename) {
		String suffix = "";
		int pos = filename.lastIndexOf('.');
		if (pos > 0 && pos < filename.length() - 1) {
			suffix = filename.substring(pos + 1);
		}
		return suffix;
	}

	private boolean upftp(FtpUtil ftpserver, String dir, String[] dirs,
			String filename, String filepath) {
		File file = new File(filepath);
		if (file.exists() == false) {
			System.out.println("上传文件" + filename + "不存在！");
			return false;
		}

		FileInputStream in = null;
		boolean flag = true;
		try {
			in = new FileInputStream(file);
			if (ftpserver.makedir(dirs) == false) {
				System.out.println("上传文件夹创建失败！");
				return false;
			}

			ftpserver.uploadFile(in, dir, filename);
		} catch (FileNotFoundException e) {
			System.out.println("上传文件流不存在！");
			flag = false;
		} catch (IOException e) {
			e.printStackTrace();
			flag = false;
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					flag = false;
					e.printStackTrace();
				}
			}
		}
		return flag;
	}

	private FtpUtil getftpserver(String ftpUrl, String ftpPort,
			String username, String password) {
		FtpInfo ftpInfo = new FtpInfo();
		ftpInfo.setIp(ftpUrl);
		ftpInfo.setPort(Integer.parseInt(ftpPort));
		ftpInfo.setName(username);
		ftpInfo.setPassword(password);
		FtpUtil ftp = null;
		try {
			ftp = new FtpUtil(ftpInfo);
			ftp.connectServer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ftp;
	}

	private String getfilename(String path) {
		String[] sp = path.split("\\\\");
		String fname = new String(sp[sp.length - 1]);
		return fname;
	}

	private String tmpFilePath() {
		return UUID.randomUUID().toString();
	}

	private String ftpDir(String dir, String businesscode, String businessnumber) {
		StringBuilder dirpath = new StringBuilder();
		dirpath.append(dir).append("/");
		dirpath.append(businesscode).append("/");
		dirpath.append(ym()).append("/");
		dirpath.append(businessnumber).append("/");
		return dirpath.toString();
	}

	private String saveDir(String businesscode, String businessnumber) {
		StringBuilder dirpath = new StringBuilder();
		dirpath.append(businesscode).append("/");
		dirpath.append(ym()).append("/");
		dirpath.append(businessnumber).append("/");
		return dirpath.toString();
	}

	private String[] ftpDirs(String dir, String businesscode,
			String businessnumber) {
		String[] path = new String[4];
		path[0] = dir;
		path[1] = businesscode;
		path[2] = ym();
		path[3] = businessnumber;
		return path;
	}

	private String ym() {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
		return format.format(new Date());
	}
}