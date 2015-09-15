package com.szgr.common.upload;

import java.io.File;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.common.PropertyConfigurer.PropertyConfigurerAcesse;
import com.szgr.framework.authority.UserInfo;

@Controller
@RequestMapping("/UploadController")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class UploadController {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/getFileList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public String getFileListHtml(@RequestParam("attachmentCode")
	String attachmentCode, @RequestParam("businessCode")
	String businessCode, @RequestParam("businessNumber")
	String businessNumber, @RequestParam("isDefault")
	String isDefault) {
		String sql = "select a.attachmentname as attachmentname,a.address as address,a.filesize as filesize,a.attachmentid as attachmentid from COMM_ATTACHMENT a where a.attachmentcode = '"
				+ attachmentCode
				+ "' and a.businesscode = '"
				+ businessCode
				+ "' and a.businessnumber = '"
				+ businessNumber
				+ "' and a.isdefault = '" + isDefault + "'";
		// System.out.println("-----" + sql);
		SQLQuery query = hibernateTemplate.getSessionFactory()
				.getCurrentSession().createSQLQuery(sql).addScalar(
						"attachmentname", Hibernate.STRING).addScalar(
						"address", Hibernate.STRING).addScalar("filesize",
						Hibernate.BIG_DECIMAL).addScalar("attachmentid",
						Hibernate.STRING);
		List list = query.list();
		StringBuffer fileListHtml = new StringBuffer();
		String ftpDir = (String) PropertyConfigurerAcesse
				.getContextProperty("ftpDir");
		//String dir = ftpDir(ftpDir, businessCode, businessNumber);
		for (int i = 0; i < list.size(); i++) {
			Object[] o = (Object[]) list.get(i);
			String fileName = (String) o[0];
			String attachmentid = (String) o[3];
			String address = (String) o[1];
			BigDecimal fileSize = (BigDecimal) o[2];
			String dir = ftpDir(ftpDir, businessCode,address, businessNumber);
			fileListHtml.append("<tr class='template-download fade in'>");
			
			fileListHtml.append("<td class='preview'>");
			fileListHtml.append("<a href='UploadServlet?getXfile=" + fileName
					+ "&ftp_path=" + dir + "' download='" + fileName + "'>����</a>");
			fileListHtml.append("</td>");
			
			fileListHtml.append("<td class='preview'>");
			fileListHtml.append("<a href='UploadServlet?getfile=" + fileName
					+ "&ftp_path=" + dir + "' title='" + fileName
					+ "' rel='show_group' download='" + fileName
					+ "'><img src='UploadServlet?getthumb=" + fileName
					+ "&ftp_path=" + dir + "'></a>");
			fileListHtml.append("</td>");
			fileListHtml.append("<td class='name'>");
			fileListHtml.append("<a href='UploadServlet?getfile=" + fileName
					+ "&ftp_path=" + dir + "' title='" + fileName
					+ "' rel='gallery' download='" + fileName + "'>" + fileName
					+ "</a>");
			fileListHtml.append("</td>");
			fileListHtml.append("<td class='size'><span>"
					+ _formatFileSize(fileSize) + "</span></td>");
			fileListHtml.append("<td class='delete'>");
			fileListHtml.append("<button class='btn btn-danger' data-type='GET' data-url='UploadServlet?delfile="
							+ fileName
							+ "&ftp_path="
							+ dir
							+ "&attachmentid="
							+ attachmentid + "'>");
			fileListHtml.append("<i class='icon-trash icon-white'></i>");
			fileListHtml.append("<span>ɾ��</span>");
			fileListHtml.append("</button>");
			fileListHtml
					.append("<input type='checkbox' name='delete' value='1'>");
			fileListHtml.append("</td>");
			fileListHtml.append("</tr>");
		}
		return fileListHtml.toString();
	}

	public String _formatFileSize(BigDecimal bytes) {
		// bytes.divide(BigDecimal.valueOf(1000000000)) ;
		// bytes.setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue();
		if (bytes.compareTo(BigDecimal.valueOf(1000000000)) == 1) {
			return bytes.divide(BigDecimal.valueOf(1000000000)).setScale(2,
					BigDecimal.ROUND_HALF_UP)
					+ " GB";
		}
		if (bytes.compareTo(BigDecimal.valueOf(1000000)) == 1) {
			return bytes.divide(BigDecimal.valueOf(1000000)).setScale(2,
					BigDecimal.ROUND_HALF_UP)
					+ " MB";
		}
		return bytes.divide(BigDecimal.valueOf(1000)).setScale(2,
				BigDecimal.ROUND_HALF_UP)
				+ " KB";

	}

	@RequestMapping(value = "/getAttachmentCodes")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getAttachmentCodes(@RequestParam("businessCode")
	String businessCode) {
		JSONObject jSONObject = new JSONObject();
		String sql = "select a.attachmentcode as attachmentcode,a.attachmentname as attachmentname,b.businesscode as businesscode,b.isdefault as isdefault from COD_ATTACHMENT a left join BAS_BUSINESSATTACHMENT b on a.attachmentcode = b.attachmentcode and b.businesscode = '"
				+ businessCode + "' ";
		SQLQuery query = hibernateTemplate.getSessionFactory()
				.getCurrentSession().createSQLQuery(sql).addScalar(
						"attachmentcode", Hibernate.STRING).addScalar(
						"attachmentname", Hibernate.STRING).addScalar(
						"businesscode", Hibernate.STRING).addScalar(
						"isdefault", Hibernate.STRING);
		List list = query.list();
		JSONArray attachmentJsonArray = new JSONArray();
		for (int i = 0; i < list.size(); i++) {
			AttachmentBo attachmentBo = new AttachmentBo();
			Object[] o = (Object[]) list.get(i);
			String attachmentcode = (o[0] == null ? "" : o[0].toString());
			String attachmentname = (o[1] == null ? "" : o[1].toString());
			String businesscode = (o[2] == null ? "" : o[2].toString());
			String isdefault = (o[3] == null ? "" : o[3].toString());
			attachmentBo.setAttachmentcode(attachmentcode);
			attachmentBo.setAttachmentname(attachmentname);
			attachmentBo.setBusinesscode(businesscode);
			attachmentBo.setIsdefault(isdefault);
//			attachmentBo.setTaxempcode(taxempcode);
			attachmentJsonArray.add(attachmentBo);
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();// ����map
		jsonMap.put("total", list.size());// rows�� ���ÿҳ��¼ list
		jsonMap.put("rows", attachmentJsonArray);// rows�� ���ÿҳ��¼ list
		jSONObject.putAll(jsonMap);
		System.out.println(jSONObject);
		return jSONObject;
	}
	
	private String ftpDir(String dir, String businesscode, String address,String businessnumber) {
		StringBuilder dirpath = new StringBuilder();
		dirpath.append(businesscode).append("/");
		dirpath.append(address).append("/");
		dirpath.append(businessnumber);
		return dirpath.toString();
	}
//	private String ftpDir(String dir, String businesscode, String address,String businessnumber) {
//		//dir = dir.replaceAll("\\\\", "/");
//		StringBuilder dirpath = new StringBuilder();
//		dirpath.append(dir).append("/");
//		dirpath.append(businesscode).append("/");
//		dirpath.append(address).append("/");
//		dirpath.append(businessnumber);
//		System.out.println("ǰ"+dirpath);
//		String r = dirpath.toString();
//		r = r.replaceAll("/", "\\\\");
//		System.out.println("��"+r);
//		return r;
//	}
//	private String ftpDir(String dir, String businesscode, String businessnumber) {
//		StringBuilder dirpath = new StringBuilder();
//		dirpath.append(dir).append("/");x
//		dirpath.append(businesscode).append("/");
//		dirpath.append(ym()).append("/");
//		dirpath.append(businessnumber).append("/");
//		return dirpath.toString();
//	}



	
//	private String ftpDir(String dir, String businesscode, String address,String businessnumber) {
//		
//		StringBuilder dirpath = new StringBuilder();
//		dirpath.append(dir).append("\\");
//		dirpath.append(businesscode).append("\\");
//		dirpath.append(address).append("\\");
//		dirpath.append(businessnumber);
//		String r = dirpath.toString();
//		r = r.replaceAll("\\\\\\\\", "\\\\");
//		System.out.println("r:"+r);
//		return r;
//	}
}
