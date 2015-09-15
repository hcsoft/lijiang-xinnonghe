package com.szgr.attachment;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.common.PropertyConfigurer.PropertyConfigurerAcesse;
import com.szgr.common.upload.vo.CodAttachmentVO;
import com.szgr.common.upload.vo.CommAttachmentVO;
import com.szgr.framework.authority.datarights.OptionObject;
import com.szgr.framework.cache.service.CacheService;
import com.szgr.util.DateUtils;

@Controller
@RequestMapping( { "/attachmentServlet" })
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class ProjectServlet {
	private static final Logger log = Logger.getLogger(ProjectServlet.class);
	private static String BUS_ESTATE = "BUS_ESTATE";
	private static String BUS_LANDSTORE = "BUS_LANDSTORE";
	@Autowired
	HibernateTemplate hibernateTemplate;
	int j = 1;


	@RequestMapping( { "/querybusestates" })
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public String queryAttachments(@RequestParam("attachmentcode")
	String attachmentcode, @RequestParam("businessnumber")
	String businessnumber) {
		/**
		List<BusEstateBVO> businessS = getBeforeBusEstateS(new String[] {
				businessnumber, tableclass });
		// 排序
		Collections.sort(businessS, new Comparator<BusEstateBVO>() {
			public int compare(BusEstateBVO arg0, BusEstateBVO arg1) {
				return arg1.getRownumber() - arg0.getRownumber();
			}
		});
		int size = businessS.size();
		BusEstateBVO before_last_vo = (BusEstateBVO) businessS.get(size - 1);
		String tablename = before_last_vo.getTableclass();
		String businessnum = before_last_vo.getBusinessnumber();
		businessS = getAfterBusEstateS(businessnum, size);
		int k = 1;
		for (BusEstateBVO vo : businessS) {
			vo.setRownumber(k++);
		}
		this.rList = null;
		this.j = 1;
		**/
		StringBuffer sql = new StringBuffer(
				" from CommAttachmentVO where   businessnumber ='" +businessnumber+"' and attachmentcode ='"+attachmentcode+"'");
		/**
		for (int i = 0; i < businessS.size(); i++) {
			BusEstateBVO vo = (BusEstateBVO) businessS.get(i);
			String businumber = vo.getBusinessnumber().trim();
			sql.append("'" + businumber + "'");
			if (i < businessS.size() - 1)
				sql.append(",");
		}
		sql.append(") ");**/
		System.out.println("CommAttachmentVO  sql :" + sql);
		List<CommAttachmentVO> attachmentlist = this.hibernateTemplate
				.getSessionFactory().getCurrentSession().createQuery(
						sql.toString()).list();
		//************************************************************
		 StringBuffer fileListHtml = new StringBuffer();
		    String ftpDir = (String)
		      PropertyConfigurerAcesse.getContextProperty("ftpDir");
		      fileListHtml.append("<tr class='template-download fade in'>");

		      fileListHtml.append("<td style='height:10px' align = 'center'><span>格式</span>");
		      fileListHtml.append("</td>");
		      fileListHtml.append("<td class='name' align = 'center'><span>文件名</span>");
		      fileListHtml.append("</td>");
		      fileListHtml.append("<td class='size' align = 'center'><span>上传人</span></td>");
		      fileListHtml.append("<td class='size' align = 'center' colspan='2'><span>上传时间</span></td>");
		      fileListHtml.append("</tr>");
		      for (int i = 0; i < attachmentlist.size(); i++) {
		    	CommAttachmentVO vo = attachmentlist.get(i);
		      String fileName = vo.getAttachmentname();
		      String attachmentid = vo.getAttachmentid();
		      String address = vo.getAddress();
		      BigDecimal fileSize = vo.getFilesize();
		      
		      String businesscode = vo.getBusinesscode();
		      String businessnumber_v =vo.getBusinessnumber();
		      Date uploadDate = vo.getUploaddate();
		      List<OptionObject> list10=CacheService.getCachelist("COD_TAXEMPCODE");
		      String username = vo.getUsercode();
		      for(OptionObject obj :list10){
		    	  if(obj.getKey().equals(username)){
		    		  username = obj.getValue();
		    		  break;
		    	  }
		      }
		      String dir = ftpDir(ftpDir, businesscode, address, businessnumber_v);
		      String imgname= "UploadServletUtil?getthumb=" + fileName + 
		      "&ftp_path=" + dir ;
		      String type = "pdf";
		      String fpdFilename = fileName;
			  if(fileName.endsWith("xls")){
				  imgname = "/images/xls.png";
				  fpdFilename = fpdFilename.substring(0,fpdFilename.lastIndexOf("."))+".pdf";
			  }else if(fileName.endsWith("xlsx")){
				  imgname = "/images/xlsx.png";
				  fpdFilename = fpdFilename.substring(0,fpdFilename.lastIndexOf("."))+".pdf";
			  }else if(fileName.endsWith("jpg")){
				  imgname = "/images/jpg.png";
				  type = "img";
			  }else if(fileName.endsWith("doc")){
				  imgname = "/images/doc.png";
				  fpdFilename = fpdFilename.substring(0,fpdFilename.lastIndexOf("."))+".pdf";
			  }else if(fileName.endsWith("docx")){
				  imgname = "/images/docx.png";
				  fpdFilename = fpdFilename.substring(0,fpdFilename.lastIndexOf("."))+".pdf";
			  }else if(fileName.endsWith("pdf")){
				  imgname = "/images/pdf.png";
			  }else if(fileName.endsWith("txt")){
				  imgname = "/images/txt.png";
			  }
			  
		      fileListHtml.append("<tr class='template-download fade in'>");

		      fileListHtml.append("<td style='height:10px'>");
//		      fileListHtml.append("<a href='javascript:void(0)' onclick=preview('"+type+"','UploadServletUtil','" + fpdFilename + 
//		        "','" + dir + "') title='" + fileName + 
//		        "' rel='show_group' download='" + fileName + 
//		        "'><img src='"+imgname+"' style='height: 60px;'></a>");
		      fileListHtml.append("<img src='"+imgname+"' style='height: 60px;'>");
		      //fileListHtml.append("<img src='"+imgname+"'>");
		      fileListHtml.append("</td>");
		      fileListHtml.append("<td class='name'>");
		      fileListHtml.append("<a href='UploadServletUtil?getfile=" + fileName + 
		        "&ftp_path=" + dir + "' title='" + fileName + 
		        "' rel='gallery' download='" + fileName + "'>" +  vo.getInputperson() + 
		        "</a>");
		      fileListHtml.append("</td>");
		      fileListHtml.append("<td class='size'><span>" + 
		    		  username + "</span></td>");
		      fileListHtml.append("</td>");
		      fileListHtml.append("<td class='size'><span>" + 
		    		  DateUtils.parseDate(uploadDate) + "</span></td>");
		      fileListHtml.append("<td class='delete'>");
		      fileListHtml.append("<button class='btn btn-danger' data-type='GET' onclick=deleteAttachment('"+attachmentcode+"','"+businessnumber+"','UploadServletUtil?delfile=" + 
		        fileName + 
		        "&ftp_path=" + 
		        dir + 
		        "&attachmentid=" + 
		        attachmentid + "')>");
		      fileListHtml.append("<i class='icon-trash icon-white'></i>");
		      fileListHtml.append("<span>删除</span>");
		      fileListHtml.append("</button>");
		      //fileListHtml
		  //      .append("<input type='checkbox' name='delete' value='1'>");
		      fileListHtml.append("</td>");
		      fileListHtml.append("</tr>");
		    }
		    return fileListHtml.toString();
		
	}
	
	 private String ftpDir(String dir, String businesscode, String address, String businessnumber) {
		    StringBuilder dirpath = new StringBuilder();
		    dirpath.append(businesscode).append("/");
		    dirpath.append(address).append("/");
		    dirpath.append(businessnumber);
		    return dirpath.toString();
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

	 
	 	@RequestMapping( { "/queryBusEstatesType" })
		@ResponseBody
		@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
		public JSONObject queryAttachmentsType(@RequestParam("businessnumber")
		String businessnumber,@RequestParam("businesscode")
		String businesscode ) {
//			StringBuffer sql = new StringBuffer(
//					" from CommAttachmentVO where   businessnumber ='" +businessnumber+"' and businesscode ='"+businesscode+"'");
////					" select b from BasBusinessattachmentVO a,CodAttachmentVO b  where   a.businesscode ='"+businesscode+"'" +
////							" and a.attachmentcode= b.attachmentcode and b.valid='01' ");
//			System.out.println("CodAttachmentVO  sql :" + sql);
//			List<CodAttachmentVO> attachmentlist = this.hibernateTemplate
//					.getSessionFactory().getCurrentSession().createQuery(
//							sql.toString()).list();
//			//************************************************************
//			
//			StringBuffer sql2 = new StringBuffer(
//					" from CommAttachmentVO   where   businessnumber ='"+businessnumber+"'");
//			System.out.println("CommAttachmentVO  sql :" + sql);
//			List<CommAttachmentVO> attachmentlist2 = this.hibernateTemplate
//			.getSessionFactory().getCurrentSession().createQuery(
//					sql2.toString()).list();
//			List<CodAttachmentVO> zdyAttachment = new ArrayList<CodAttachmentVO>();
//			List<String> attachmentcodes =  new ArrayList<String>();
//			for(CodAttachmentVO vo: attachmentlist){
//				attachmentcodes.add(vo.getAttachmentcode());
//			}
//			for(CommAttachmentVO vo: attachmentlist2){
//				if(!attachmentcodes.contains(vo.getAttachmentcode()) && !vo.getAttachmentcode().equals("00") && !vo.getAttachmentcode().trim().equals("") && vo.getAttachmentcode()!=null){
//					attachmentcodes.add(vo.getAttachmentcode());
//					CodAttachmentVO tmp = new CodAttachmentVO();
//					tmp.setAttachmentcode(vo.getAttachmentcode());
//					tmp.setAttachmentname(vo.getAttachmenttypename());
//					tmp.setValid("00");
//					zdyAttachment.add(tmp);
//				}
//			}
	 		List<CodAttachmentVO> attachmentlist = new ArrayList<CodAttachmentVO>();
			JSONObject jSONObject = new JSONObject();
			jSONObject.put("attachmentType", attachmentlist);
			return  jSONObject;
	 }
	 	
	 	@RequestMapping( { "/deleteAttachmentZdy" })
		@ResponseBody
		@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
		public void deleteAttachmentZdy(@RequestParam("businessnumber")
		String businessnumber,@RequestParam("attachmentcode")
		String attachmentcode ) {
	 		String sql = "delete from CommAttachmentVO where  businessnumber ='"+businessnumber+"' and  attachmentcode ='"+attachmentcode+"'";
	 		this.hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(sql).executeUpdate();
	 }
}