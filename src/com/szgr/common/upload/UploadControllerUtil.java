package com.szgr.common.upload;

import com.szgr.common.PropertyConfigurer.PropertyConfigurerAcesse;
import java.io.PrintStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.hibernate.SessionFactory;
import org.hibernate.classic.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping({"/UploadControllerUtil"})
@Transactional(rollbackFor={Exception.class, Exception.class})
public class UploadControllerUtil
{

  @Autowired
  HibernateTemplate hibernateTemplate;

  @RequestMapping({"/getFileList"})
  @ResponseBody
  @Transactional(propagation=Propagation.NOT_SUPPORTED, readOnly=true)
  public String getFileListHtml(@RequestParam("attachmentid") String attachment_id)
  {
    System.out.println();
    String sql = new String("select a.attachmentname as attachmentname,a.address as address,a.filesize as filesize, a.attachmentid as attachmentid,a.businesscode as businesscode,a.businessnumber  as businessnumber  from COMM_ATTACHMENT a   where  a.attachmentid='" + 
      attachment_id + "'   ");

    System.out.println("-----附件查询-----" + sql);
    SQLQuery query = this.hibernateTemplate.getSessionFactory()
      .getCurrentSession().createSQLQuery(sql).addScalar(
      "attachmentname", Hibernate.STRING).addScalar(
      "address", Hibernate.STRING).addScalar("filesize", 
      Hibernate.BIG_DECIMAL).addScalar("attachmentid", 
      Hibernate.STRING)
      .addScalar("businesscode", Hibernate.STRING)
      .addScalar("businessnumber", Hibernate.STRING);
    List list = query.list();
    StringBuffer fileListHtml = new StringBuffer();
    String ftpDir = (String)
      PropertyConfigurerAcesse.getContextProperty("ftpDir");

    for (int i = 0; i < list.size(); i++) {
      Object[] o = (Object[])list.get(i);

      String fileName = (String)o[0];
      String attachmentid = (String)o[3];
      String address = (String)o[1];
      BigDecimal fileSize = (BigDecimal)o[2];
      
      String businesscode = (String)o[4];
      String businessnumber = (String)o[5];
      
      String dir = ftpDir(ftpDir, businesscode, address, businessnumber);
      String imgname= "UploadServletUtil?getthumb=" + fileName + 
      "&ftp_path=" + dir ;
	  if(fileName.endsWith("xls") || fileName.endsWith("xlsx")){
		  imgname = "/images/excel.png";
	  }else if(fileName.endsWith("jpg")){
		  imgname = "/images/image.png";
	  }else if(fileName.endsWith("doc") || fileName.endsWith("docx")){
		  imgname = "/images/word.png";
	  }else if(fileName.endsWith("pdf")){
		  imgname = "/images/pdf.png";
	  }
      fileListHtml.append("<tr class='template-download fade in'>");

      fileListHtml.append("<td style='height:10px'>");
      fileListHtml.append("<a href='UploadServletUtil?getfile=" + fileName + 
        "&ftp_path=" + dir + "' title='" + fileName + 
        "' rel='show_group' download='" + fileName + 
        "'><img src='"+imgname+"'></a>");
      fileListHtml.append("</td>");
      fileListHtml.append("<td class='name'>");
      fileListHtml.append("<a href='UploadServletUtil?getfile=" + fileName + 
        "&ftp_path=" + dir + "' title='" + fileName + 
        "' rel='gallery' download='" + fileName + "'>" +  fileName + 
        "</a>");
      fileListHtml.append("</td>");
      fileListHtml.append("<td class='size'><span>" + 
        _formatFileSize(fileSize) + "</span></td>");

      fileListHtml.append("<td class='delete'>");
      fileListHtml.append("<button class='btn btn-danger' data-type='GET' data-url='UploadServletUtil?delfile=" + 
        fileName + 
        "&ftp_path=" + 
        dir + 
        "&attachmentid=" + 
        attachmentid + "'>");
      fileListHtml.append("<i class='icon-trash icon-white'></i>");
      fileListHtml.append("<span>删除</span>");
      fileListHtml.append("</button>");
      fileListHtml
        .append("<input type='checkbox' name='delete' value='1'>");
      fileListHtml.append("</td>");
      fileListHtml.append("</tr>");
    }
    return fileListHtml.toString();
  }

  public String _formatFileSize(BigDecimal bytes)
  {
    if (bytes.compareTo(BigDecimal.valueOf(1000000000L)) == 1) {
      return bytes.divide(BigDecimal.valueOf(1000000000L))
        .setScale(2, 
        4) + 
        " GB";
    }
    if (bytes.compareTo(BigDecimal.valueOf(1000000L)) == 1) {
      return bytes.divide(BigDecimal.valueOf(1000000L))
        .setScale(2, 
        4) + 
        " MB";
    }
    return bytes.divide(BigDecimal.valueOf(1000L))
      .setScale(2, 
      4) + 
      " KB";
  }
  @RequestMapping({"/getAttachmentCodes"})
  @ResponseBody
  @Transactional(propagation=Propagation.NOT_SUPPORTED, readOnly=true)
  public JSONObject getAttachmentCodes(@RequestParam("businessCode") String businessCode) {
    JSONObject jSONObject = new JSONObject();
    String sql = "select a.attachmentcode as attachmentcode,a.attachmentname as attachmentname,b.businesscode as businesscode,b.isdefault as isdefault from COD_ATTACHMENT a left join BAS_BUSINESSATTACHMENT b on a.attachmentcode = b.attachmentcode and b.businesscode = '" + 
      businessCode + "' ";
    SQLQuery query = this.hibernateTemplate.getSessionFactory()
      .getCurrentSession().createSQLQuery(sql).addScalar(
      "attachmentcode", Hibernate.STRING).addScalar(
      "attachmentname", Hibernate.STRING).addScalar(
      "businesscode", Hibernate.STRING).addScalar(
      "isdefault", Hibernate.STRING);
    List list = query.list();
    JSONArray attachmentJsonArray = new JSONArray();
    for (int i = 0; i < list.size(); i++) {
      AttachmentBo attachmentBo = new AttachmentBo();
      Object[] o = (Object[])list.get(i);
      String attachmentcode = o[0] == null ? "" : o[0].toString();
      String attachmentname = o[1] == null ? "" : o[1].toString();
      String businesscode = o[2] == null ? "" : o[2].toString();
      String isdefault = o[3] == null ? "" : o[3].toString();
      attachmentBo.setAttachmentcode(attachmentcode);
      attachmentBo.setAttachmentname(attachmentname);
      attachmentBo.setBusinesscode(businesscode);
      attachmentBo.setIsdefault(isdefault);

      attachmentJsonArray.add(attachmentBo);
    }
    Map jsonMap = new HashMap();
    jsonMap.put("total", Integer.valueOf(list.size()));
    jsonMap.put("rows", attachmentJsonArray);
    jSONObject.putAll(jsonMap);
    System.out.println(jSONObject);
    return jSONObject;
  }

  private String ftpDir(String dir, String businesscode, String address, String businessnumber) {
    StringBuilder dirpath = new StringBuilder();
    dirpath.append(businesscode).append("/");
    dirpath.append(address).append("/");
    dirpath.append(businessnumber);
    return dirpath.toString();
  }
}