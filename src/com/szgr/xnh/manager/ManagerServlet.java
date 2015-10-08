package com.szgr.xnh.manager;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun.org.apache.commons.beanutils.BeanUtils;
import com.szgr.common.uid.UUIDGener;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.authority.vo.SystemUser2roleVO;
import com.szgr.framework.pagination.PageUtil;
import com.szgr.util.Keyvalue;
import com.szgr.util.ReturnObj;
import com.szgr.vo.KeyTablekeyvaluesPK;
import com.szgr.vo.KeyTablekeyvaluesVO;
import com.szgr.vo.XnhNotice2empVO;
import com.szgr.vo.XnhNoticeVO;
import com.thtf.ynds.vo.CodTaxempcodeVO;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

@Controller
@RequestMapping("/Manager")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class ManagerServlet {
	private static final String ORG_FORMAT = "000000000000"; 
	private static final String ORG_FORMAT2 = "00"; 

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/getorglist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getOrgList(CodTaxorgcodeBvo req) {
		String taxorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String authflag = SystemUserAccessor.getInstance().getAuthflag();//是否允许查看下级机关数据
		String sql = "select taxorgcode,taxorgname,parentId,valid from COD_TAXORGCODE  where  1=1  ";//查询出除已审核状态的数据
//		if (req.getUser_id() != null
//				&& !"".equals(req.getUser_id())) {
//			sql = sql + " and getUser_id='" + req.getUser_id() + "'";
//		}
		if("01".equals(authflag)){
			List ls =this.getChildorglist(taxorgcode);
			String taxorgcodes ="";
			for (Iterator iterator = ls.iterator(); iterator.hasNext();) {
				CodTaxorgcodeVO orgvo = (CodTaxorgcodeVO) iterator.next();
				taxorgcodes = taxorgcodes+"'"+orgvo.getTaxorgcode()+"',";
			}
			taxorgcodes = taxorgcodes.substring(0, taxorgcodes.length()-1);
			sql = sql + " and taxorgcode in ("+taxorgcodes+")";
		}else{
			sql = sql + " and parentId ='"+taxorgcode+"'";
		}
//		if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(8, 10))){//村、街道
//			sql = sql + " and  taxorgcode ='"+taxorgcode+"')";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(6, 8))){//乡镇
//			sql = sql + " and (taxorgcode  in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or taxorgcode ='"+taxorgcode+"')";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(4, 6))){//县级机关
//			sql = sql + " and (taxorgcode  in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"')  or taxorgcode ='"+taxorgcode+"')";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(2, 4))){//州市级机关
//			sql = sql + " and (taxorgcode  in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from COD_TAXORGCODE where parentId in (select taxorgcode from COD_TAXORGCODE where parentId='"+taxorgcode+"')) or taxorgcode ='"+taxorgcode+"')";
//		}else if(taxorgcode.length()>=10 && !"00".equals(taxorgcode.substring(0, 2))){//省
//			
//		}
		sql = sql +" order by taxorgcode";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("taxorgcode", Hibernate.STRING);
		attrMap.put("taxorgname", Hibernate.STRING);
		attrMap.put("parentId", Hibernate.STRING);
		attrMap.put("valid", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(req.getPage()), 15, CodTaxorgcodeBvo.class,
				hibernateTemplate.getSessionFactory().getCurrentSession(),
				attrMap);
		// System.out.println(jSONObject);a
		return jSONObject;
	}

	@RequestMapping(value = "/saveorg")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public void saveOrg(CodTaxorgcodeVO req) throws Exception{
		Session session = hibernateTemplate.getSessionFactory().getCurrentSession();
		String taxorgcode="";
		String format ="";
		if(req.getTaxorgcode() !=null && !"".equals(req.getTaxorgcode())){//修改
			taxorgcode = req.getTaxorgcode();
		}else{
			String hql = "from CodTaxorgcodeVO where parentId ='"+req.getParentId()+"' order by taxorgcode desc ";
			List list = session.createQuery(hql).list();
			BigDecimal a = null;
			if(list != null && list.size()>0){
				
				CodTaxorgcodeVO maxvo = (CodTaxorgcodeVO) list.get(0);
				if(!"00".equals(maxvo.getTaxorgcode().substring(6, 8))){//乡镇
					DecimalFormat df2 = new DecimalFormat(ORG_FORMAT2);
					a = new BigDecimal(maxvo.getTaxorgcode().substring(6, 8));
					BigDecimal b = a.add(new BigDecimal(1));
					format = df2.format(b);
					taxorgcode =  maxvo.getTaxorgcode().substring(0, 6)+format+"0001";
				}else if( !"00".equals(maxvo.getTaxorgcode().substring(4, 6))){//县级机关
					DecimalFormat df2 = new DecimalFormat(ORG_FORMAT2);
					a = new BigDecimal(maxvo.getTaxorgcode().substring(4, 6));
					BigDecimal b = a.add(new BigDecimal(1));
					format = df2.format(b);
					taxorgcode =  maxvo.getTaxorgcode().substring(0, 4)+format+"000001";
				}else if(!"00".equals(maxvo.getTaxorgcode().substring(2, 4))){//州市级机关
					DecimalFormat df2 = new DecimalFormat(ORG_FORMAT2);
					a = new BigDecimal(maxvo.getTaxorgcode().substring(2, 4));
					BigDecimal b = a.add(new BigDecimal(1));
					format = df2.format(b);
					taxorgcode =  maxvo.getTaxorgcode().substring(0, 2)+format+"00000001";
				}
//				a = new BigDecimal(maxvo.getTaxorgcode());
//				BigDecimal b = a.add(new BigDecimal(1));
//				DecimalFormat df = new DecimalFormat(ORG_FORMAT);
//				taxorgcode = df.format(b);
			}else{
				if(req.getParentId().length()>=10 && !"00".equals(req.getParentId().substring(6, 8))){//乡镇
					taxorgcode =  req.getParentId().substring(0, 8)+"0101";
				}else if(req.getParentId().length()>=10 && !"00".equals(req.getParentId().substring(4, 6))){//县级机关
					taxorgcode =  req.getParentId().substring(0, 6)+"010001";
				}else if(req.getParentId().length()>=10 && !"00".equals(req.getParentId().substring(2, 4))){//州市级机关
					taxorgcode =  req.getParentId().substring(0, 4)+"01000001";
				}
			}
		}
		try {
			req.setTaxorgcode(taxorgcode);
			req.setTaxorgshortname(req.getTaxorgname());
			req.setRootnode("");
			req.setOrgclass("");
			req.setOrgtype("");
			session.saveOrUpdate(req);
			//新增机构增加流水号(user_id,taxempcode)
			KeyTablekeyvaluesPK pk = new KeyTablekeyvaluesPK();
			System.out.println("taxorgcode="+taxorgcode);
			pk.setTaxorgcode(taxorgcode);
			pk.setKeyname("taxempcode");
			KeyTablekeyvaluesVO keyTablekeyvaluesVO = new KeyTablekeyvaluesVO();
			keyTablekeyvaluesVO.setPrimaryKey(pk);
			keyTablekeyvaluesVO.setFormatpro(taxorgcode);//获取机关代码前10位
			keyTablekeyvaluesVO.setMaxvalue(new BigDecimal(1));
			keyTablekeyvaluesVO.setDatalength(15);
			keyTablekeyvaluesVO.setLast_frtime(new Date());
			session.save(keyTablekeyvaluesVO);
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		
		
	}
	
	@RequestMapping(value = "/getorg")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public CodTaxorgcodeVO getOrg(@RequestParam("taxorgcode") String taxorgcode) {
		CodTaxorgcodeVO vo = (CodTaxorgcodeVO) hibernateTemplate
				.getSessionFactory().getCurrentSession()
				.get(CodTaxorgcodeVO.class, taxorgcode);
		return vo;
	}
	
	@RequestMapping(value = "/delorg")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String delOrg(@RequestParam("taxorgcode") String taxorgcode) {
		String hql = "delete from CodTaxorgcodeVO where taxorgcode ='"+taxorgcode+"'";
		hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
		hql = "delete from KeyTablekeyvaluesVO where primaryKey.taxorgcode ='"+taxorgcode+"'";
		hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
		return "1";
	}
	
	@RequestMapping(value = "/getemplist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getEmpList(CodTaxempcodeBvo req) {
		String taxorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String authflag = SystemUserAccessor.getInstance().getAuthflag();//是否允许查看下级机关数据
		String sql = "select taxempcode,taxorgcode,logincode,taxempname,password,normalflag,doctorflag,nurseflag,publicdoctorflag,valid from COD_TAXEMPCODE  where  1=1  ";//查询出除已审核状态的数据
		if (req.getTaxempcode() != null
				&& !"".equals(req.getTaxempcode())) {
			sql = sql + " and taxempcode='" + req.getTaxempcode() + "'";
		}
		if (req.getLogincode() != null
				&& !"".equals(req.getLogincode())) {
			sql = sql + " and logincode='" + req.getLogincode() + "'";
		}
		if (req.getTaxempname() != null
				&& !"".equals(req.getTaxempname())) {
			sql = sql + " and taxempname like '%" + req.getTaxempname() + "%'";
		}
		if("01".equals(authflag)){
			List ls =this.getChildorglist(taxorgcode);
			String taxorgcodes ="";
			for (Iterator iterator = ls.iterator(); iterator.hasNext();) {
				CodTaxorgcodeVO orgvo = (CodTaxorgcodeVO) iterator.next();
				taxorgcodes = taxorgcodes+"'"+orgvo.getTaxorgcode()+"',";
			}
			taxorgcodes = taxorgcodes.substring(0, taxorgcodes.length()-1);
			sql = sql + " and taxorgcode in ("+taxorgcodes+")";
		}else{
			sql = sql + " and taxorgcode ='"+taxorgcode+"'";
		}
//		sql = sql + " and taxorgcode = '"+taxorgcode+"'";
		sql = sql +" order by taxempcode";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("taxempcode", Hibernate.STRING);
		attrMap.put("taxorgcode", Hibernate.STRING);
		attrMap.put("logincode", Hibernate.STRING);
		attrMap.put("taxempname", Hibernate.STRING);
		attrMap.put("password", Hibernate.STRING);
		attrMap.put("normalflag", Hibernate.STRING);
		attrMap.put("doctorflag", Hibernate.STRING);
		attrMap.put("nurseflag", Hibernate.STRING);
		attrMap.put("publicdoctorflag", Hibernate.STRING);
		attrMap.put("valid", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(req.getPage()), 15, CodTaxempcodeBvo.class,
				hibernateTemplate.getSessionFactory().getCurrentSession(),
				attrMap);
		// System.out.println(jSONObject);a
		return jSONObject;
	}
	
	public List getChildorglist(String taxorgcode){
		String hql = "from CodTaxorgcodeVO where 1=1 ";
		hql = hql  + " and (taxorgcode  in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"') or parentId in (select taxorgcode from CodTaxorgcodeVO where parentId in (select taxorgcode from CodTaxorgcodeVO where parentId='"+taxorgcode+"')) or taxorgcode ='"+taxorgcode+"')";
		List ls = hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).list();
		return ls;
	}
	
	@RequestMapping(value = "/getrolelist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public List getRolelist(){
		String hql = "from SystemRolesVO where 1=1 and enabled='1' ";
		List ls = hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).list();
		return ls;
	}
	
	@RequestMapping(value = "/saveemp")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public ReturnObj saveEmp(@RequestBody HashMap<String, List> map) throws Exception{
		Session session = hibernateTemplate.getSessionFactory().getCurrentSession();
		LinkedHashMap userinfo = (LinkedHashMap) map.get("userinfo");
		List<LinkedHashMap> roleList = (List<LinkedHashMap>) map.get("roles");
		ReturnObj returnObj = new ReturnObj();
		String hql="";
		String optorg = SystemUserAccessor.getInstance().getTaxorgcode();
		String taxempcode="";
		if(userinfo.get("taxempcode") !=null && !"".equals(userinfo.get("taxempcode").toString())){//修改
			
			taxempcode = userinfo.get("taxempcode").toString();
			hql = "delete from SystemUser2roleVO where user_id='"+taxempcode+"'";
			session.createQuery(hql).executeUpdate();
			session.flush();
		}else{
			hql = "from CodTaxempcodeVO where logincode ='"+userinfo.get("logincode").toString()+"'";
			List ls = session.createQuery(hql).list();
			if(ls != null && ls.size()>0){
				returnObj.setSucess(false);
				returnObj.setMessage("保存失败，该登录ID已被使用，请使用其他登录ID");
				return returnObj;
			}
			taxempcode = Keyvalue.getkeyvalue(userinfo.get("taxorgcode").toString(), "taxempcode");
			
		}
		try {
			CodTaxempcodeVO vo = new CodTaxempcodeVO();
			vo.setTaxempcode(taxempcode);
			vo.setTaxorgcode(userinfo.get("taxorgcode").toString());
			vo.setLogincode(userinfo.get("logincode").toString());
			vo.setTaxempname(userinfo.get("taxempname").toString());
			vo.setPassword(userinfo.get("password").toString());
			vo.setNormalflag(userinfo.get("normalflag")==null?"00":userinfo.get("normalflag").toString());
			vo.setDoctorflag(userinfo.get("doctorflag")==null?"00":userinfo.get("doctorflag").toString());
			vo.setNurseflag(userinfo.get("nurseflag")==null?"00":userinfo.get("nurseflag").toString());
			vo.setPublicdoctorflag(userinfo.get("publicdoctorflag")==null?"00":userinfo.get("publicdoctorflag").toString());
			vo.setAuthflag(userinfo.get("authflag")==null?"00":userinfo.get("authflag").toString());
			vo.setValid(userinfo.get("valid")==null?"00":userinfo.get("valid").toString());
			session.saveOrUpdate(vo);
	//		List role_ids = req.getRole_ids();
			for (int i = 0; i < roleList.size(); i++) {
				String role_id = (String) roleList.get(i).get("role_id");
				SystemUser2roleVO systemUser2roleVO = new SystemUser2roleVO();
				systemUser2roleVO.setSerial_id(UUIDGener.getUUID());
				systemUser2roleVO.setRole_id(role_id);
				systemUser2roleVO.setUser_id(taxempcode);
				hibernateTemplate.save(systemUser2roleVO);
				hibernateTemplate.flush();
			}
		
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		returnObj.setSucess(true);
		returnObj.setMessage("保存成功");
		return returnObj;
	}
	
	@RequestMapping(value = "/getemp")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public CodTaxempcodeBvo getEmp(@RequestParam("taxempcode") String taxempcode){
		CodTaxempcodeVO codTaxempcodeVO = (CodTaxempcodeVO) hibernateTemplate.getSessionFactory().getCurrentSession().get(CodTaxempcodeVO.class, taxempcode);
		CodTaxempcodeBvo bvo = new CodTaxempcodeBvo();
		if(codTaxempcodeVO !=null){
			try {
				BeanUtils.copyProperties(bvo, codTaxempcodeVO);
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		String hql = "from SystemUser2roleVO where user_id='"+taxempcode+"'";
		List ls = hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).list();
		bvo.setRoles(ls);
		return bvo;
	}
	
	@RequestMapping(value = "/getnoticelist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getNoticeList(NoticeBvo req) {
		String taxorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String authflag = SystemUserAccessor.getInstance().getAuthflag();//是否允许查看下级机关数据
		String sql = "select id,title,content,datebegin,dateend,to_orgcode,opt_orgcode,opt_empcode,optdate,valid from xnh_notice  where  1=1  ";
		if(req.getTitle() != null && !"".equals(req.getTitle())){
			sql = sql + "and title like '%"+req.getTitle()+"%'";
		}
		if(req.getOptdatebegin() != null && !"".equals(req.getOptdatebegin())){
			sql = sql + "and optdate >= '"+req.getOptdatebegin()+"'";
		}
		if(req.getOptdateend() != null && !"".equals(req.getOptdateend())){
			sql = sql + "and optdate <= '"+req.getOptdateend()+"'";
		}
		sql = sql +" order by optdate";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("id", Hibernate.STRING);
		attrMap.put("title", Hibernate.STRING);
		attrMap.put("content", Hibernate.STRING);
		attrMap.put("datebegin", Hibernate.DATE);
		attrMap.put("dateend", Hibernate.DATE);
		attrMap.put("to_orgcode", Hibernate.STRING);
		attrMap.put("opt_orgcode", Hibernate.STRING);
		attrMap.put("opt_empcode", Hibernate.STRING);
		attrMap.put("optdate", Hibernate.DATE);
		attrMap.put("valid", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(req.getPage()), 15, NoticeBvo.class,
				hibernateTemplate.getSessionFactory().getCurrentSession(),
				attrMap);
		// System.out.println(jSONObject);a
		return jSONObject;
	}
	
	@RequestMapping(value = "/savenotice")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public void saveNotice(NoticeBvo req) throws Exception{
		Session session = hibernateTemplate.getSessionFactory().getCurrentSession();
		String taxorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String taxempcode = SystemUserAccessor.getInstance().getTaxempcode();
		String id="";
		String hql ="";
		if(req.getId() !=null && !"".equals(req.getId())){//修改
			id = req.getId();
		}else{
			id = UUIDGener.getUUID();
		}
		try {
			XnhNoticeVO noticeVO = new XnhNoticeVO();
			noticeVO.setId(id);
			noticeVO.setTitle(req.getTitle());
			noticeVO.setContent(req.getContent());
			noticeVO.setTo_orgcode(req.getTo_orgcode());
			noticeVO.setValid(req.getValid());
			noticeVO.setOpt_empcode(taxempcode);
			noticeVO.setOpt_orgcode(taxorgcode);
			noticeVO.setOptdate(new Date());
			session.saveOrUpdate(noticeVO);
			hql = "delete from XnhNotice2empVO where noticeid = '"+id+"'";
			session.createQuery(hql).executeUpdate();
			session.flush();
			hql = " from CodTaxempcodeVO where taxorgcode in ("+req.getTo_orgcode()+")";
			List ls = session.createQuery(hql).list();
			if(ls != null && ls.size()>0){
				for (Iterator iterator = ls.iterator(); iterator.hasNext();) {
					CodTaxempcodeVO vo = (CodTaxempcodeVO) iterator.next();
					XnhNotice2empVO tovo = new XnhNotice2empVO();
					tovo.setSerialno(UUIDGener.getUUID());
					tovo.setNoticeid(id);
					tovo.setEmpcode(vo.getTaxempcode());
					tovo.setReadflag("00");
					session.save(tovo);
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
	}
	
	@RequestMapping(value = "/getnotice")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public XnhNoticeVO getNotice(@RequestParam("id") String id) {
		XnhNoticeVO vo = (XnhNoticeVO) hibernateTemplate
				.getSessionFactory().getCurrentSession()
				.get(XnhNoticeVO.class, id);
		vo.setTo_orgcode(vo.getTo_orgcode().replace("'", ""));
		return vo;
	}
	
	@RequestMapping(value = "/delnotice")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String delNotice(@RequestParam("id") String id) {
		String hql = "delete from XnhNoticeVO where id ='"+id+"'";
		hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
		hql = "delete from XnhNotice2empVO where noticeid ='"+id+"'";
		hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
		return "1";
	}
	
	@RequestMapping(value = "/getusernoticelist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getUsernoticeList(NoticeBvo req) {
		String taxempcode = SystemUserAccessor.getInstance().getTaxempcode();
		String sql = "select a.id as id ,a.title as title,a.content as content,a.datebegin as datebegin,a.dateend as dateend," +
				"a.to_orgcode as to_orgcode,a.opt_orgcode as opt_orgcode,a.opt_empcode as opt_empcode,a.optdate as optdate,a.valid as valid," +
				"b.readflag as readflag from xnh_notice a,xnh_notice2emp b  where  a.id = b.noticeid   ";
		sql = sql + "and b.empcode ='"+taxempcode+"'";
		if(req.getTitle() != null && !"".equals(req.getTitle())){
			sql = sql + "and title like '%"+req.getTitle()+"%'";
		}
		if(req.getOptdatebegin() != null && !"".equals(req.getOptdatebegin())){
			sql = sql + "and optdate >= '"+req.getOptdatebegin()+"'";
		}
		if(req.getOptdateend() != null && !"".equals(req.getOptdateend())){
			sql = sql + "and optdate <= '"+req.getOptdateend()+"'";
		}
		sql = sql +" order by optdate";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("id", Hibernate.STRING);
		attrMap.put("title", Hibernate.STRING);
		attrMap.put("content", Hibernate.STRING);
		attrMap.put("datebegin", Hibernate.DATE);
		attrMap.put("dateend", Hibernate.DATE);
		attrMap.put("to_orgcode", Hibernate.STRING);
		attrMap.put("opt_orgcode", Hibernate.STRING);
		attrMap.put("opt_empcode", Hibernate.STRING);
		attrMap.put("optdate", Hibernate.DATE);
		attrMap.put("valid", Hibernate.STRING);
		attrMap.put("readflag", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(req.getPage()), 15, NoticeBvo.class,
				hibernateTemplate.getSessionFactory().getCurrentSession(),
				attrMap);
		// System.out.println(jSONObject);a
		return jSONObject;
	}
	
	@RequestMapping(value = "/readnotice")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public XnhNoticeVO readNotice(@RequestParam("id") String id) {
		XnhNoticeVO vo = (XnhNoticeVO) hibernateTemplate
				.getSessionFactory().getCurrentSession()
				.get(XnhNoticeVO.class, id);
		String taxempcode = SystemUserAccessor.getInstance().getTaxempcode();
		String hql = "update XnhNotice2empVO set readflag='01' where noticeid='"+id+"' and empcode ='"+taxempcode+"'";
		hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
		hibernateTemplate.getSessionFactory().getCurrentSession().clear();
		return vo;
	}
}


