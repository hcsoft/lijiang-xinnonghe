package com.szgr.xnh.derate;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.common.uid.UUIDGener;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.pagination.PageUtil;
import com.szgr.framework.util.StringUtil;
import com.szgr.vo.XnhDerateVO;
import com.szgr.vo.XnhUserVO;
import com.szgr.xnh.user.ChangecardBvo;

@Controller
@RequestMapping("/Derate")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class DerateServlet {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/getuserlist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getUserInfo(QueryBean req) {
		String sql = "select user_id,union_id,card_id,user_name,person_no,gender,birthday,age,idnumber,province,city,area,town,village,team,address,telephone,pic,org_code,leader_flag,leader_id,leader_relation,role_id,hospital_id,valid "
				+ " from xnh_user  where  1=1  ";//查询出除已审核状态的数据
		if (req.getUser_id() != null
				&& !"".equals(req.getUser_id())) {
			sql = sql + " and user_id='" + req.getUser_id() + "'";
		}
		if (req.getUnion_id() != null
				&& !"".equals(req.getUnion_id())) {//新农合证
			sql = sql + " and union_id='" + req.getUnion_id() + "'";
		}
		if (req.getCard_id() != null
				&& !"".equals(req.getCard_id())) {//卡号
			sql = sql + " and card_id='" + req.getCard_id() + "'";
		}
		if (req.getUser_name() != null
				&& !"".equals(req.getUser_name())) {//姓名
			sql = sql + " and user_name like '%" + req.getUser_name() + "%'";
		}
		if (req.getPerson_no() != null
				&& !"".equals(req.getPerson_no())) {//个人编号
			sql = sql + " and person_no = '" + req.getPerson_no() + "'";
		}
		sql = sql +" order by user_id";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("user_id", Hibernate.STRING);
		attrMap.put("union_id", Hibernate.STRING);
		attrMap.put("card_id", Hibernate.STRING);
		attrMap.put("user_name", Hibernate.STRING);
		attrMap.put("person_no", Hibernate.STRING);
		attrMap.put("gender", Hibernate.STRING);
		attrMap.put("birthday", Hibernate.DATE);
		attrMap.put("age", Hibernate.INTEGER);
		attrMap.put("idnumber", Hibernate.STRING);
		attrMap.put("province", Hibernate.STRING);
		attrMap.put("city", Hibernate.STRING);
		attrMap.put("area", Hibernate.STRING);
		attrMap.put("town", Hibernate.STRING);
		attrMap.put("village", Hibernate.STRING);
		attrMap.put("team", Hibernate.STRING);
		attrMap.put("address", Hibernate.STRING);
		attrMap.put("telephone", Hibernate.STRING);
		attrMap.put("pic", Hibernate.STRING);
		attrMap.put("org_code", Hibernate.STRING);
		attrMap.put("leader_flag", Hibernate.STRING);
		attrMap.put("leader_id", Hibernate.STRING);
		attrMap.put("leader_relation", Hibernate.STRING);
		attrMap.put("role_id", Hibernate.STRING);
		attrMap.put("valid", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(req.getPage()), 15, XnhUserVO.class,
				hibernateTemplate.getSessionFactory().getCurrentSession(),
				attrMap);
		// System.out.println(jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/saveDerate")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String saveDerate(
			@RequestBody HashMap<String, List> map) throws Exception {
		String optorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String optempcode = SystemUserAccessor.getInstance().getTaxempcode();
		LinkedHashMap maininfo = (LinkedHashMap) map.get("maininfo");
		
		String user_id = (String) maininfo.get("user_id");
		XnhUserVO uservo = (XnhUserVO) hibernateTemplate.getSessionFactory().getCurrentSession().get(XnhUserVO.class, user_id);
		if(uservo == null){
			throw new Exception("该用户不存在");
		}
		String derate_type = (String) maininfo.get("derate_type");
		List insertedlist = (List) map.get("inserted");
		List deletedlist = (List) map.get("deleted");
		List updatedlist = (List) map.get("updated");
		JSONParser parser = new JSONParser();
		if (insertedlist != null && insertedlist.size() > 0) {
			for (int i = 0; i < insertedlist.size(); i++) {
				LinkedHashMap insertmap = (LinkedHashMap) insertedlist.get(i);
				XnhDerateVO derateVO = new XnhDerateVO();
				derateVO.setSerialno(UUIDGener.getUUID());
				derateVO.setUser_id(user_id);
				derateVO.setUnion_id(uservo.getUnion_id());
				derateVO.setCard_id(uservo.getCard_id());
				derateVO.setHospital_begindate(insertmap.get("hospital_begindate")==null?null:StringUtil.stringToDate(insertmap.get("hospital_begindate").toString()));
				derateVO.setHospital_enddate(insertmap.get("hospital_enddate")==null?null:StringUtil.stringToDate(insertmap.get("hospital_enddate").toString()));
				derateVO.setDiagnose(insertmap.get("diagnose")==null?"":insertmap.get("diagnose").toString());
				derateVO.setDerate_type(derate_type);
				derateVO.setDerate_date(StringUtil.stringToDate(insertmap.get("derate_date").toString()));
				derateVO.setActual_amount(new BigDecimal(insertmap.get("actual_amount").toString()));
				derateVO.setDerate_amount(new BigDecimal(insertmap.get("derate_amount").toString()));
				derateVO.setDerate_sumamount(new BigDecimal(insertmap.get("derate_sumamount").toString()));
				derateVO.setOpt_empcode(optempcode);
				derateVO.setOpt_orgcode(optorgcode);
				derateVO.setDoctor(insertmap.get("doctor")==null?"":insertmap.get("doctor").toString());
				derateVO.setOptdate(new Date());
				hibernateTemplate.getSessionFactory().getCurrentSession().save(derateVO);
				hibernateTemplate.getSessionFactory().getCurrentSession().flush();
				hibernateTemplate.getSessionFactory().getCurrentSession().clear();
			}
		}
		if (deletedlist != null && deletedlist.size() > 0) {
			for (int i = 0; i < deletedlist.size(); i++) {
				LinkedHashMap deletemap = (LinkedHashMap) deletedlist.get(i);
				String serialno = deletemap.get("serialno").toString();
				String hql = "delete from XnhDerateVO where serialno='"+ serialno + "'";
				hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
				hibernateTemplate.getSessionFactory().getCurrentSession().flush();
				hibernateTemplate.getSessionFactory().getCurrentSession().clear();
			}
		}
		if (updatedlist != null && updatedlist.size() > 0) {
			for (int i = 0; i < updatedlist.size(); i++) {
				LinkedHashMap updatemap = (LinkedHashMap) updatedlist.get(i);
				String hospital_begindate = updatemap.get("hospital_begindate")==null?null:"'"+updatemap.get("hospital_begindate").toString()+"'";
				String hospital_enddate = updatemap.get("hospital_enddate")==null?null:"'"+updatemap.get("hospital_enddate").toString()+"'";
				String diagnose = updatemap.get("diagnose")==null?null:"'"+updatemap.get("diagnose").toString()+"'";
				String doctor = updatemap.get("doctor")==null?null:"'"+updatemap.get("doctor").toString()+"'";
				String hql = "update XnhDerateVO set hospital_begindate="
						+ hospital_begindate + ","
						+ "hospital_enddate ="
						+ hospital_enddate + ","
						+ "diagnose ="
						+ diagnose + ","
						+ "derate_date ='"
						+ updatemap.get("derate_date").toString() + "',"
						+ "actual_amount ="
						+ updatemap.get("actual_amount").toString() + ", "
						+ "derate_amount ="
						+ updatemap.get("derate_amount").toString() + ", "
						+ "derate_sumamount ="
						+ updatemap.get("derate_sumamount").toString() + ", "
						+ "opt_orgcode ='"
						+ optorgcode + "', "
						+ "opt_empcode ='"
						+ optempcode + "', "
						+ "doctor ="
						+ doctor + ", optdate=getdate() "
						+ " where serialno='"
						+ updatemap.get("serialno").toString() + "'";
				hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(hql).executeUpdate();
				hibernateTemplate.getSessionFactory().getCurrentSession().flush();
				hibernateTemplate.getSessionFactory().getCurrentSession().clear();
			}
		}
		return "操作成功";
	}

	
	@RequestMapping(value = "/getDeratelist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getDeratelist(QueryBean req) {
		String sql = "select serialno,user_id,hospital_begindate,hospital_enddate,diagnose,derate_type,derate_date,actual_amount,derate_amount,derate_sumamount,doctor,opt_orgcode,opt_empcode "
				+ " from xnh_derate  where  1=1  ";//查询出除已审核状态的数据
		if (req.getUser_id() != null
				&& !"".equals(req.getUser_id())) {
			sql = sql + " and user_id='" + req.getUser_id() + "'";
		}
		if (req.getDerate_type() != null
				&& !"".equals(req.getDerate_type())) {//新农合证
			sql = sql + " and derate_type='" + req.getDerate_type() + "'";
		}
		sql = sql +" order by derate_date";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("user_id", Hibernate.STRING);
		attrMap.put("serialno", Hibernate.STRING);
		attrMap.put("hospital_begindate", Hibernate.DATE);
		attrMap.put("hospital_enddate", Hibernate.DATE);
		attrMap.put("diagnose", Hibernate.STRING);
		attrMap.put("derate_type", Hibernate.STRING);
		attrMap.put("derate_date", Hibernate.DATE);
		attrMap.put("actual_amount", Hibernate.BIG_DECIMAL);
		attrMap.put("derate_amount", Hibernate.BIG_DECIMAL);
		attrMap.put("derate_sumamount", Hibernate.BIG_DECIMAL);
		attrMap.put("opt_orgcode", Hibernate.STRING);
		attrMap.put("opt_empcode", Hibernate.STRING);
		attrMap.put("doctor", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(req.getPage()), 15, XnhDerateVO.class,
				hibernateTemplate.getSessionFactory().getCurrentSession(),
				attrMap);
		return jSONObject;
	}
	

	@RequestMapping(value = "/deleteuser")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public String deleteUserInfo(
			@RequestParam("user_id") String user_id) {
		String hql1 = "delete from XnhUserVO where user_id= '"
				+ user_id + "'";
		String hql2 = "delete from XnhUserVO where leader_id= '"
				+ user_id + "'";
		hibernateTemplate.getSessionFactory().getCurrentSession()
				.createQuery(hql1).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession()
				.createQuery(hql2).executeUpdate();
		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
		return "0";
	}
	
	@RequestMapping(value = "/updateUnioninfo")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public Map updateUnioninfo(ChangecardBvo req) {
		Map retMap = new HashMap();
		XnhUserVO vo = (XnhUserVO) hibernateTemplate.getSessionFactory().getCurrentSession().get(XnhUserVO.class, req.getUser_id());
		vo.setCard_id(req.getNew_card_id());
		vo.setUnion_id(req.getUnion_id());
		try {
			hibernateTemplate.getSessionFactory().getCurrentSession().saveOrUpdate(vo);
			hibernateTemplate.getSessionFactory().getCurrentSession().flush();
			hibernateTemplate.getSessionFactory().getCurrentSession().clear();
			retMap.put("state", true);
			retMap.put("message","操作成功！");
		} catch (Exception e) {
			retMap.put("state", false);
			retMap.put("message","操作失败！");
		}
		
		return retMap;
	}
//
//	@RequestMapping(value = "/getlandstoresub")
//	@ResponseBody
//	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
//	public List getLandstoresub(@RequestParam("landstoreid") String landstoreid) {
//		String hql = "from BusLandstoresubVO where landstoreid ='" + landstoreid
//				+ "'";
//		List<BusLandstoresubBvo> returnList = new ArrayList<BusLandstoresubBvo>();
//		List<BusLandstoresubVO> subvolist = hibernateTemplate
//				.getSessionFactory().getCurrentSession().createQuery(hql)
//				.list();
//		for (BusLandstoresubVO busLandstoresubVO : subvolist) {
//			BusLandstoresubBvo bvo = new BusLandstoresubBvo();
//			bvo.setLandstorsubid(busLandstoresubVO.getLandstorsubid());
//			bvo.setLandstoreid(busLandstoresubVO.getLandstoreid());
//			bvo.setLocation(busLandstoresubVO.getLocation());
//			bvo.setDetailaddress(busLandstoresubVO.getDetailaddress());
//			bvo.setAreatotal(busLandstoresubVO.getAreatotal());
//			bvo.setAreaplough(busLandstoresubVO.getAreaplough());
//			bvo.setAreabuild(busLandstoresubVO.getAreabuild());
//			bvo.setAreauseless(busLandstoresubVO.getAreauseless());
//			bvo.setAreasell(busLandstoresubVO.getAreasell());
//			bvo.setBelongtocountry(busLandstoresubVO.getLocation().substring(0, 9));
//			bvo.setBelongtowns(busLandstoresubVO.getLocation());
//			returnList.add(bvo);
//		}
//		return returnList;
//	}
//
//	// @RequestMapping(value = "/savelandstoresub")
//	// @ResponseBody
//	// @Transactional(propagation = Propagation.REQUIRED)
//	// public List saveLandstoresub(@RequestBody HashMap<String, List> map)
//	// throws java.text.ParseException {
//	// List insertedlist = (List) map.get("inserted");
//	// List deletedlist = (List) map.get("deleted");
//	// List updatedlist = (List) map.get("updated");
//	// LinkedHashMap baseinfomap = (LinkedHashMap) map.get("baseinfo");
//	// JSONParser parser = new JSONParser();
//	// String landstoreid = baseinfomap.get("landstoreid").toString();
//	// // System.out.println("--1--landstoreid="+landstoreid);
//	// BusLandstoreVO mainvo = (BusLandstoreVO) hibernateTemplate
//	// .getSessionFactory().getCurrentSession()
//	// .get(BusLandstoreVO.class, landstoreid);
//	// if (insertedlist != null && insertedlist.size() > 0) {
//	// for (int i = 0; i < insertedlist.size(); i++) {
//	// LinkedHashMap insertmap = (LinkedHashMap) insertedlist.get(i);
//	// BusLandstoresubVO vo = new BusLandstoresubVO();
//	// vo.setLandstorsubid(UUIDGener.getUUID());
//	// vo.setLandstorid(landstoreid);
//	// vo.setLocation(insertmap.get("location").toString());
//	// vo.setAreaplough(new BigDecimal(insertmap.get("areaplough")
//	// .toString()));
//	// vo.setAreabuild(new BigDecimal(insertmap.get("areabuild")
//	// .toString()));
//	// vo.setAreauseless(new BigDecimal(insertmap.get("areauseless")
//	// .toString()));
//	// vo.setAreatotal(new BigDecimal(insertmap.get("areaplough")
//	// .toString())
//	// .add(new BigDecimal(insertmap.get("areabuild")
//	// .toString()))
//	// .add(new BigDecimal(insertmap.get("areauseless")
//	// .toString()))
//	// .setScale(2, BigDecimal.ROUND_HALF_UP));// 总面积
//	// hibernateTemplate.getSessionFactory().getCurrentSession()
//	// .save(vo);
//	// hibernateTemplate.getSessionFactory().getCurrentSession()
//	// .flush();
//	// }
//	// }
//	// if (deletedlist != null && deletedlist.size() > 0) {
//	// for (int i = 0; i < deletedlist.size(); i++) {
//	// LinkedHashMap deletemap = (LinkedHashMap) deletedlist.get(i);
//	// String landstorsubid = deletemap.get("landstorsubid")
//	// .toString();
//	// String hql = "delete from BusLandstoresubVO where landstorsubid='"
//	// + landstorsubid + "'";
//	// hibernateTemplate.getSessionFactory().getCurrentSession()
//	// .createQuery(hql).executeUpdate();
//	// hibernateTemplate.getSessionFactory().getCurrentSession()
//	// .flush();
//	// }
//	// }
//	// if (updatedlist != null && updatedlist.size() > 0) {
//	// for (int i = 0; i < updatedlist.size(); i++) {
//	// LinkedHashMap updatemap = (LinkedHashMap) updatedlist.get(i);
//	// String hql = "update BusLandstoresubVO set location='"+
//	// updatemap.get("location").toString() + "',"
//	// + "areaplough ="+ updatemap.get("areaplough").toString() + ","
//	// + "areabuild =" + updatemap.get("areabuild").toString()+ ","
//	// + "areauseless ="+ updatemap.get("areauseless").toString()+","
//	// + "areatotal =" + updatemap.get("areaplough").toString()+"+" +
//	// updatemap.get("areabuild").toString()+"+" +
//	// updatemap.get("areauseless").toString()
//	// + " where landstorsubid='"
//	// + updatemap.get("landstorsubid").toString() + "'";
//	// hibernateTemplate.getSessionFactory().getCurrentSession()
//	// .createQuery(hql).executeUpdate();
//	// hibernateTemplate.getSessionFactory().getCurrentSession()
//	// .flush();
//	// }
//	// }
//	// calculateArea(mainvo);
//	// List ls = getLandstoresub(landstoreid);
//	// return ls;
//	// }
//
//	private void calculateArea(BusLandstoreVO mainvo) {
//		// System.out.println("--2--landstoreid="+mainvo.getLandstoreid());
//		// 更新房产原值
//		BigDecimal sumareatotal = new BigDecimal(0);
//		BigDecimal sumareaplough = new BigDecimal(0);
//		BigDecimal sumareabuild = new BigDecimal(0);
//		BigDecimal sumareauseless = new BigDecimal(0);
//		String sql1 = "select case when sum(areatotal)>=0 then sum(areatotal) else 0 end as sumareatotal, "
//				+ "case when sum(areaplough)>=0 then sum(areaplough) else 0 end as sumareaplough,"
//				+ "case when sum(areabuild)>=0 then sum(areabuild) else 0 end as sumareabuild,"
//				+ "case when sum(areauseless)>=0 then sum(areauseless) else 0 end as sumareauseless "
//				+ " from BUS_LANDSTORESUB where landstoreid='"
//				+ mainvo.getLandstoreid() + "'";
//		SQLQuery sqlQuery = hibernateTemplate.getSessionFactory()
//				.getCurrentSession().createSQLQuery(sql1);
//		List<Object[]> list = sqlQuery.list();
//		if (list.size() > 0) {
//			Object[] o = (Object[]) list.get(0);
//			sumareatotal = new BigDecimal(o[0].toString());
//			sumareaplough = new BigDecimal(o[1].toString());
//			sumareabuild = new BigDecimal(o[2].toString());
//			sumareauseless = new BigDecimal(o[3].toString());
//		}
//		// System.out.println("sumareatotal="+sumareatotal);
//		// System.out.println("sumareaplough="+sumareaplough);
//		// System.out.println("sumareabuild="+sumareabuild);
//		// System.out.println("sumareauseless="+sumareauseless);
//		mainvo.setAreatotal(sumareatotal);
//		mainvo.setAreaplough(sumareaplough);
//		mainvo.setAreabuild(sumareabuild);
//		mainvo.setAreauseless(sumareauseless);
//		mainvo.setAreaploughtax(mainvo.getAreatotal()
//				.subtract(mainvo.getAreasell())
//				.subtract(mainvo.getAreaplough())
//				.subtract(mainvo.getAreaploughfreetax())
//				.subtract(mainvo.getAreabuild())
//				.subtract(mainvo.getAreauseless()));
//		hibernateTemplate.getSessionFactory().getCurrentSession()
//				.update(mainvo);
//		hibernateTemplate.getSessionFactory().getCurrentSession().flush();
//		hibernateTemplate.getSessionFactory().getCurrentSession().clear();
//	}
//
//	/*
//	 * 获取所属乡镇下拉
//	 */
//	@RequestMapping(value = "/getlocationComboxs")
//	@ResponseBody
//	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
//	public JSONArray getFuncMenuTops() {
//		// SystemUserAccessor.getInstance().ge
//	
//		List<OptionObject> cacheList = CacheService
//				.getCachelist("COD_DISTRICT");
//
//		JSONArray arrays = new JSONArray();
//		OptionObject optionObjectnull = new OptionObject("", "", "");
//		arrays.add(optionObjectnull);
//		if (cacheList != null && cacheList.size() > 0) {
//			for (int i = 0; i < cacheList.size(); i++) {
//				OptionObject optionObject = cacheList.get(i);
//				ComboBox bo = new ComboBox();
//				if (optionObject.getKey().startsWith("530122") && optionObject.getKey().length()>6) {
//					bo.setKey(optionObject.getKey());
//					bo.setValue(optionObject.getValue());
//					bo.setKeyvalue(optionObject.getKeyvalue());
////					System.out.println(optionObject.getKeyvalue());
//					arrays.add(bo);
//				}
//			}
//		}
//		return arrays;
//	}
//
//	@RequestMapping(value = "/getreginfo")
//	@ResponseBody
//	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
//	public JSONObject getReginfo(@RequestParam("taxpayerid") String taxpayerid,
//			@RequestParam("taxpayername") String taxpayername,
//			@RequestParam("orgunifycode") String orgunifycode,
//			@RequestParam("page") String page, @RequestParam("rows") String rows) {
//		String sql = "select a.taxpayerid as taxpayerid,a.taxpayername as taxpayername,b.taxorgshortname as taxdeptcode,c.taxempname as taxmanagercode,a.orgunifycode as orgunifycode"
//				+ " from REG_TAXREGISTMAIN a,COD_TAXORGCODE b,COD_TAXEMPCODE c where a.taxdeptcode=b.taxorgcode and a.taxmanagercode = c.taxempcode  ";
//		String taxorgcode = SystemUserAccessor.getInstance().getTaxorgcode()
//				.substring(0, 6)
//				+ "0000";
//		System.out.println("taxorgcode = " + taxorgcode);
//		if (taxpayerid != null && !"".equals(taxpayerid)) {
//			sql = sql + " and a.taxpayerid = '" + taxpayerid + "'";
//		}
//		if (taxpayername != null && !"".equals(taxpayername)) {
//			sql = sql + " and a.taxpayername like '%" + taxpayername + "%'";
//		}
//		if (orgunifycode != null && !"".equals(orgunifycode)) {
//			sql = sql + " and a.orgunifycode = '" + orgunifycode + "'";
//		}
//		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
//		attrMap.put("taxpayerid", Hibernate.STRING);
//		attrMap.put("taxpayername", Hibernate.STRING);
//		attrMap.put("taxdeptcode", Hibernate.STRING);
//		attrMap.put("taxmanagercode", Hibernate.STRING);
//		attrMap.put("orgunifycode", Hibernate.STRING);
//
//		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
//				Integer.parseInt(page), Integer.parseInt(rows),
//				RegTaxregistmainVO.class, hibernateTemplate.getSessionFactory()
//						.getCurrentSession(), attrMap);
//
//		return jSONObject;
//	}
//	
//	/*
//	 * 获取系统参数
//	 */
//	private String getRegParams(String taxorgcode,String parametername)
//	{
//		Session session = hibernateTemplate.getSessionFactory().getCurrentSession();
//		//产权转移类型
//		String sql = "from PrmRegParamsVO where taxorgcode='"+taxorgcode+"' and parametername='"+parametername+"'";
//		try{
//			PrmRegParamsVO param=(PrmRegParamsVO)session.createQuery(sql).uniqueResult();
//			return param.getParametervalue();
//		}catch(Exception e)
//		{
//			return null;
//		}
//	}
}
