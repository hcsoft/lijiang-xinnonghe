package com.szgr.xnh.derate;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.type.Type;
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

import com.szgr.common.sp.SpUtil;
import com.szgr.common.uid.UUIDGener;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.pagination.PageUtil;
import com.szgr.framework.util.StringUtil;
import com.szgr.vo.XnhDerateVO;
import com.szgr.vo.XnhUserVO;
import com.szgr.xnh.user.ChangecardBvo;

@Controller
@RequestMapping("/Deratequery")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class DerateQueryServlet {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/getuserlist")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getUserInfo(QueryBean req) {
		String sql = "select a.user_id as user_id,b.user_name as user_name,a.derate_type as derate_type,a.derate_date as derate_date,a.actual_amount as actual_amount," +
				"age,idnumber,province,city,area,town,village,team,address,telephone,pic,org_code,leader_flag,leader_id,leader_relation,role_id,hospital_id,valid "
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
			@RequestBody HashMap<String, List> map) {
		String optorgcode = SystemUserAccessor.getInstance().getTaxorgcode();
		String optempcode = SystemUserAccessor.getInstance().getTaxempcode();
		LinkedHashMap maininfo = (LinkedHashMap) map.get("maininfo");
		XnhUserVO vo;
		String user_id = (String) maininfo.get("user_id");
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
						+ optempcode + "' "
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
		String sql = "select serialno,user_id,hospital_begindate,hospital_enddate,diagnose,derate_type,derate_date,actual_amount,derate_amount,derate_sumamount,opt_orgcode,opt_empcode "
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

	@RequestMapping(value = "/getderatesum")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getDeratesum(QueryBean req) {
		String sql = "{call P_DERATE_SUM(?,?,?,?,?,?,?,?)}";
		Session hbtSession =hibernateTemplate.getSessionFactory().getCurrentSession();
		String[] sumtype = req.getSumtype().split(",");
		String column="";
		String selectas = "";
		String groupby = "group by ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		for (int i = 0; i < sumtype.length; i++) {
			if(sumtype[i].equals("derate_date_year")){
				column = column + "substring(CONVERT(varchar(20),derate_date,23),1,4) as derate_date_year,";
				groupby = groupby + "substring(CONVERT(varchar(20),derate_date,23),1,4),";
				selectas = selectas +"derate_date_year,";
				attrMap.put("derate_date_year", Hibernate.STRING);
			}else if(sumtype[i].equals("derate_date_yearmonth")){
				column = column + "substring(CONVERT(varchar(20),derate_date,23),1,7) as derate_date_yearmonth,";
				groupby = groupby + "substring(CONVERT(varchar(20),derate_date,23),1,7),";
				selectas = selectas +"derate_date_yearmonth,";
				attrMap.put("derate_date_yearmonth", Hibernate.STRING);
			}else if(sumtype[i].equals("derate_date_yearmonthday")){
				column = column + "substring(CONVERT(varchar(20),derate_date,23),1,10) as derate_date_yearmonthday,";
				groupby = groupby + "substring(CONVERT(varchar(20),derate_date,23),1,10),";
				selectas = selectas +"derate_date_yearmonthday,";
				attrMap.put("derate_date_yearmonthday", Hibernate.STRING);
			}else if(sumtype[i].equals("opt_orgcode")){
				column = column + "opt_orgcode,";
				groupby = groupby + "opt_orgcode,";
				selectas = selectas +"opt_orgcode,";
				attrMap.put("opt_orgcode", Hibernate.STRING);
			}else if(sumtype[i].equals("user_id")){
				column = column + "user_id,";
				groupby = groupby + "user_id,";
				selectas = selectas +"user_id,";
				attrMap.put("user_id", Hibernate.STRING);
			}else if(sumtype[i].equals("union_id")){
				column = column + "union_id,";
				groupby = groupby + "union_id,";
				selectas = selectas +"union_id,";
				attrMap.put("union_id", Hibernate.STRING);
			}
		}
		Object[] params = new Object[] { column,groupby, selectas,req.getOpt_orgcode(),req.getDeratedatebegin(),req.getDeratedateend(),
				Integer.parseInt(req.getPage()),15};
		Type[] paramTypes = new Type[] { Hibernate.STRING, Hibernate.STRING,Hibernate.STRING,Hibernate.STRING,Hibernate.STRING,Hibernate.STRING, Hibernate.INTEGER,Hibernate.INTEGER};
		System.out.println("data exec P_DERATE_SUM '"+column+"','"+groupby+"','"+selectas+"','"+req.getOpt_orgcode()+"','"+req.getDeratedatebegin()+"','"+req.getDeratedateend()+"',"+req.getPage()+",15");
		attrMap.put("derate_date_year", Hibernate.STRING);
		attrMap.put("derate_date_yearmonth", Hibernate.STRING);
		attrMap.put("derate_date_yearmonthday", Hibernate.STRING);
		attrMap.put("user_id", Hibernate.STRING);
		attrMap.put("user_name", Hibernate.STRING);
		attrMap.put("union_id", Hibernate.STRING);
		attrMap.put("derate_type10", Hibernate.BIG_DECIMAL);//门诊
		attrMap.put("derate_type20", Hibernate.BIG_DECIMAL);//住院
		attrMap.put("opt_orgcode", Hibernate.STRING);
		attrMap.put("currentpagenum", Hibernate.INTEGER);
		attrMap.put("pagesize", Hibernate.INTEGER);
		attrMap.put("totalitemsnum", Hibernate.INTEGER);
		attrMap.put("totalpagenum", Hibernate.INTEGER);
		SpUtil sputil = new SpUtil();
		List list = null;
		try {
			list = sputil.querySp(sql, hbtSession, XnhDerateBvo.class,
					params, paramTypes, attrMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		if(list != null && list.size()>0){
			XnhDerateBvo bvo = (XnhDerateBvo) list.get(0);
			jsonMap.put("total", bvo.getTotalitemsnum());//总记录数
			jsonMap.put("rows", list);
		}else{
			jsonMap.put("total", 0);//总记录数
			jsonMap.put("rows", list);
		}
		JSONObject jSONObject = new JSONObject();
		jSONObject.putAll(jsonMap);
		return jSONObject;
	}
}
