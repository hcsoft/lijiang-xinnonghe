package com.szgr.common.upload;

import java.awt.image.BufferedImage;
import java.awt.image.BufferedImageOp;
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

import javax.activation.MimetypesFileTypeMap;
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
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.imgscalr.Scalr;
import org.json.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

public class UploadServletUtil extends HttpServlet {
	private static final Logger log = LoggerFactory
			.getLogger(UploadServletUtil.class);
	private static final long MAX_SIZE = 4194304L;
	private static final long MAX_SINGLE_SIZE = 1048576L;

	@Autowired
	HibernateTemplate hibernateTemplate;
	String ftpUrl = "";
	String ftpPort = "";
	String ftpDir = "";
	String username = "";
	String password = "";

	public void init() throws ServletException {
		super.init();

		ServletContext servletContext = getServletContext();

		WebApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(servletContext);

		this.hibernateTemplate = ((HibernateTemplate) ctx
				.getBean("hibernateTemplate"));
		this.ftpUrl = ((String) PropertyConfigurerAcesse
				.getContextProperty("ftpUrl"));
		this.ftpPort = ((String) PropertyConfigurerAcesse
				.getContextProperty("ftpPort"));
		this.ftpDir = ((String) PropertyConfigurerAcesse
				.getContextProperty("ftpDir"));
		this.username = ((String) PropertyConfigurerAcesse
				.getContextProperty("username"));
		this.password = ((String) PropertyConfigurerAcesse
				.getContextProperty("password"));
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		if ((request.getParameter("getfile") != null)
				&& (StringUtils.notEmpty(request.getParameter("getfile")))) {
			try {
				String fileName = new String(request.getParameter("getfile")
						.getBytes("ISO8859-1"), "utf-8");
				System.out.println("fileName:::" + fileName);
				ByteArrayOutputStream output = new ByteArrayOutputStream();
				FtpUtil ftpserver = getftpserver(this.ftpUrl, this.ftpPort,
						this.username, this.password);
				
				String ftpurl = request.getParameter("ftp_path");
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
				DataInputStream in = new DataInputStream(
						new ByteArrayInputStream(output.toByteArray()));

				while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
					op.write(bbuf, 0, bytes);
				}
				in.close();
				op.flush();
				op.close();
			} catch (Exception ex) {
				log.warn("读取图片文件出错!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!！");
				ex.printStackTrace();
			}
		} else if ((request.getParameter("delfile") != null)
				&& (StringUtils.notEmpty(request.getParameter("delfile")))) {
			FtpUtil ftpserver = getftpserver(this.ftpUrl, this.ftpPort,
					this.username, this.password);
			ftpserver.getFtpClient().changeWorkingDirectory(
					request.getParameter("ftp_path"));
			ftpserver.getFtpClientNotConn().deleteFile(
					new String(request.getParameter("delfile").getBytes(
							"iso-8859-1"), "gbk"));
			String attachmentid = request.getParameter("attachmentid");
			Session session = this.hibernateTemplate.getSessionFactory()
					.openSession();
			String hql = "delete CommAttachmentVO where attachmentid=:attachmentid";
			Transaction t = null;
			try {
				t = session.beginTransaction();
				Query q = session.createQuery(hql);
				q.setParameter("attachmentid", attachmentid);
				q.executeUpdate();
				t.commit();
			} catch (Exception ex) {
				if (t != null)
					t.rollback();
			} finally {
				session.close();
			}
		} else if ((request.getParameter("getthumb") != null)
				&& (StringUtils.notEmpty(request.getParameter("getthumb")))) {
			String fileName = new String(request.getParameter("getthumb")
					.getBytes("iso-8859-1"), "utf-8");
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			FtpUtil ftpserver = getftpserver(this.ftpUrl, this.ftpPort,
					this.username, this.password);
			ftpserver.getFtpClientNotConn().changeWorkingDirectory(
					request.getParameter("ftp_path"));
			ftpserver.downloadFile(fileName, output);
			InputStream is = new ByteArrayInputStream(output.toByteArray());

			String mimetype = getMimeTypeByFileName(fileName);
			if ((mimetype.endsWith("png")) || (mimetype.endsWith("jpeg"))
					|| (mimetype.endsWith("jpg")) || (mimetype.endsWith("gif"))) {
				BufferedImage im = ImageIO.read(is);
				if (im != null) {
					BufferedImage thumb = Scalr.resize(im, 60,
							new BufferedImageOp[0]);
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
		} else {
			PrintWriter writer = response.getWriter();
			writer.write("call POST with multipart form data");
		}
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String businessCode = "";
		String businessNumber = "";
		String attachmentCode = "";
		String attachmentName = "";
		String filename_w = "";
		String isDefault = "";
		String usercode = com.szgr.framework.authority.datarights.SystemUserAccessor
				.getInstance().getTaxempcode();
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
				if (item.isFormField()) {
					String field = item.getFieldName();
					if (field.equals("businessCode")) {
						businessCode = item.getString();
					} else if (field.equals("businessNumber")) {
						businessNumber = item.getString();
					} else if (field.equals("attachmentCode")) {
						attachmentCode = item.getString();
					}  else if (field.equals("attachmentName")) {
						attachmentName =new String(item.getString().getBytes(
						"ISO8859-1"), "utf-8");
					} else if (field.equals("filename")) {
						filename_w = new String(item.getString().getBytes(
						"ISO8859-1"), "utf-8");
					} else if (field.equals("isDefault")) {
						isDefault = item.getString();
					}
				}
			}
			System.out.println("attachmentName:"+attachmentName+"filename_w:"+filename_w);
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
			String address = format.format(new Date());
			String dir = ftpDir(address, businessCode, businessNumber);
			System.out.println("dir********  :" + dir);
			String[] dirs = ftpDirs(address, businessCode, businessNumber);
			FtpUtil ftpserver = getftpserver(this.ftpUrl, this.ftpPort,
					this.username, this.password);
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(2097152);
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setSizeMax(4194304L);
			upload.setFileSizeMax(1048576L);
			String tmpath = request.getRealPath("/") + "/tmp";

			BufferedInputStream bis = null;
			FileOutputStream fos = null;

			File tmpdir = new File(tmpath);
			if (!tmpdir.exists()) {
				tmpdir.mkdir();
			}

			File tmpfiledir = new File(tmpdir, tmpFilePath());
			if (!tmpfiledir.exists()) {
				tmpfiledir.mkdir();
			}

			for (FileItem item : items) {
				if (!item.isFormField()) {
					int filesize = (int) item.getSize();
					String filename = getfilename(item.getName());

					File file = new File(tmpfiledir, filename);
					
					if (!file.exists()) {
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
//					if(filename.endsWith(".doc")||filename.endsWith(".docx")||filename.endsWith(".xls")||filename.endsWith(".xlsx")){
//						JOD4DocToPDF pdf =new JOD4DocToPDF(); 
//						String absolutePath =   file.getAbsolutePath();
//						String pdfFileName = absolutePath.substring(0,absolutePath.lastIndexOf("."))+".pdf";
////						if(filename.endsWith("x")){
////							absolutePath = absolutePath.substring(0,absolutePath.length()-1);
////						}
//						File refile = new File(absolutePath);
//						file.renameTo(refile);
//						System.out.println("***********absolutePath**************"+absolutePath);
//						pdf.test(absolutePath, pdfFileName);	
//						File pdfFile = new File(pdfFileName);
//						 ftpserver = getftpserver(this.ftpUrl, this.ftpPort,
//								this.username, this.password);
//						if (upftp(ftpserver, dir, dirs, filename.substring(0,filename.lastIndexOf("."))+".pdf", pdfFile.getPath())) {
//							pdfFile.delete();
//						}
//						refile.renameTo(file);
//					}
					 ftpserver = getftpserver(this.ftpUrl, this.ftpPort,
							this.username, this.password);
					if (upftp(ftpserver, dir, dirs, filename, file.getPath())) {
						file.delete();
						Session session = this.hibernateTemplate
								.getSessionFactory().openSession();
						Transaction t = null;
						try {
							t = session.beginTransaction();
							CommAttachmentVO vo = new CommAttachmentVO();
							attachmentid = UUIDGener.getUUID();
							vo.setAttachmentid(attachmentid);
							vo.setBusinesscode(businessCode);
							vo.setBusinessnumber(businessNumber);
							vo.setAttachmentcode(attachmentCode);
							vo.setAttachmentname(item.getName());
							vo.setAttachmenttypename(attachmentName);
							vo.setFilesize(new BigDecimal(filesize));
							vo.setAddress(address);
							vo.setInputperson(filename_w);
							vo.setUploaddate(new Date());
							vo.setUsercode(usercode);
							vo.setIsdefault("00");
							//vo.setAttachmentcode("");
							this.hibernateTemplate.save(vo);
							this.hibernateTemplate.flush();
							t.commit();
						} catch (Exception ex) {
							ex.printStackTrace();
							if (t != null)
								t.rollback();
						} finally {
							session.close();
						}
						JSONObject jsono = new JSONObject();
						jsono.put("name", item.getName());
						jsono.put("size", Long.valueOf(item.getSize()));
						System.out.println("dir::::" + dir);
						jsono.put("url", "UploadServletUtil?getfile="
								+ item.getName() + "&ftp_path=" + dir);
						jsono.put("thumbnail_url",
								"UploadServletUtil?getthumb=" + item.getName()
										+ "&ftp_path=" + dir);
						jsono.put("delete_url", "UploadServletUtil?delfile="
								+ item.getName() + "&ftp_path=" + dir
								+ "&attachmentid=" + attachmentid);
						jsono.put("delete_type", "GET");

						json.put(jsono);
						System.out.println(json.toString());
					}
				}
			}

			tmpfiledir.delete();
			System.out.println("删除临时文件夹成功!");
		} catch (FileUploadException e) {
			throw new RuntimeException(e);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			System.out.println("finally:" + json.toString());
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
				MimetypesFileTypeMap mtMap = new MimetypesFileTypeMap();
				mimetype = mtMap.getContentType(file);
			}
		}
		return mimetype;
	}

	private String getMimeTypeByFileName(String fileName) {
		String mimetype = "";
		if (getSuffix(fileName).equalsIgnoreCase("png"))
			mimetype = "image/png";
		else if (getSuffix(fileName).equalsIgnoreCase("jpg"))
			mimetype = "image/jpg";
		else if (getSuffix(fileName).equalsIgnoreCase("jpeg"))
			mimetype = "image/jpeg";
		else if (getSuffix(fileName).equalsIgnoreCase("gif")) {
			mimetype = "image/gif";
		}

		return mimetype;
	}

	private String getSuffix(String filename) {
		String suffix = "";
		int pos = filename.lastIndexOf('.');
		if ((pos > 0) && (pos < filename.length() - 1)) {
			suffix = filename.substring(pos + 1);
		}
		return suffix;
	}

	private boolean upftp(FtpUtil ftpserver, String dir, String[] dirs,
			String filename, String filepath) {
		File file = new File(filepath);
		if (!file.exists()) {
			System.out.println("上传文件" + filename + "不存在！");
			return false;
		}

		FileInputStream in = null;
		boolean flag = true;
		try {
			in = new FileInputStream(file);
			if (!ftpserver.makedir(dirs)) {
				System.out.println("上传文件夹创建失败！");
				return false;
			}

			ftpserver.uploadFile(in, dir, filename);
		} catch (FileNotFoundException e) {
			System.out.println("上传文件流不存在！");
			flag = false;

			if (in != null)
				try {
					in.close();
				} catch (IOException ex) {
					flag = false;
					ex.printStackTrace();
				}
		} catch (IOException e) {
			e.printStackTrace();
			flag = false;

			if (in != null)
				try {
					in.close();
				} catch (IOException ex) {
					flag = false;
					ex.printStackTrace();
				}
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
		String fname = new String(sp[(sp.length - 1)]);
		return fname;
	}

	private String tmpFilePath() {
		return UUID.randomUUID().toString();
	}

	private String ftpDir(String dir, String businesscode, String businessnumber) {
		StringBuilder dirpath = new StringBuilder();
		dirpath.append(businesscode).append("/");
		dirpath.append(dir).append("/");
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
		String[] path = new String[3];
		path[0] = businesscode;
		path[1] = dir;
		path[2] = businessnumber;
		return path;
	}

	private String ym() {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
		return format.format(new Date());
	}
}