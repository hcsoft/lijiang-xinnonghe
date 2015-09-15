package com.szgr.framework.authority.services.authority_mgr.group2user_mgr;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
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

import com.szgr.common.uid.UUIDGener;
import com.szgr.framework.authority.vo.SystemUser2groupVO;
import com.szgr.framework.pagination.PageUtil;

@Controller
@RequestMapping("/Group2UserMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class Group2UserMgrService {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/getGroupList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getGroupList(@RequestParam("group_code_queryId")
	String group_code_queryId, @RequestParam("group_describe_queryId")
	String group_describe_queryId, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		pageSize = "15";
		String sql = " select group_id ,group_code,group_describe from SYSTEM_USERGROUPS where 1=1 ";
		if (!group_code_queryId.equals("") && group_code_queryId != null) {
			sql += " and group_code like '%" + group_code_queryId + "%'";
		}

		if (!group_describe_queryId.equals("") && group_describe_queryId != null) {
			sql += " and group_describe like '%" + group_describe_queryId + "%'";
		}

		sql += " order by group_code,group_describe ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("group_id", Hibernate.STRING);
		attrMap.put("group_code", Hibernate.STRING);
		attrMap.put("group_describe", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				GroupMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
		// System.out.println("--------" + jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/getUserList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getUserList(@RequestParam("taxorgsupcode")
	String taxorgsupcode, @RequestParam("taxorgcode")
	String taxorgcode, @RequestParam("taxdeptcode")
	String taxdeptcode, @RequestParam("taxmanagercode")
	String taxmanagercode, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		pageSize = "30";
		String sql = " select a.taxempcode as taxempcode ,b.taxorgshortname as taxorgshortname,a.taxempname as taxempname from COD_TAXEMPCODE a,COD_TAXORGCODE b where a.taxorgcode = b.taxorgcode ";
		if (!taxorgsupcode.equals("") && taxorgsupcode != null) {
			sql += " and substring(a.taxorgcode,1,4) = '"
					+ taxorgsupcode.substring(0, 4) + "'";
		}

		if (!taxorgcode.equals("") && taxorgcode != null) {
			sql += " and substring(a.taxorgcode,1,6) = '"
					+ taxorgcode.substring(0, 6) + "'";
		}

		if (!taxdeptcode.equals("") && taxdeptcode != null) {
			sql += " and a.taxorgcode = '"
					+ taxdeptcode + "'";
		}
		
		if (!taxmanagercode.equals("") && taxmanagercode != null) {
			sql += " and a.taxempcode = '" + taxmanagercode + "'";
		}
		sql += " order by a.taxorgcode,a.taxempcode ";
		
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("taxempcode", Hibernate.STRING);
		attrMap.put("taxorgshortname", Hibernate.STRING);
		attrMap.put("taxempname", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				UserMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
		 
		return jSONObject;
	}

	@RequestMapping(value = "/getGroup2UserList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getGroup2UserList(@RequestParam("group_code_queryId")
	String group_code_queryId, @RequestParam("s_taxorgsupcode")
	String s_taxorgsupcode, @RequestParam("s_taxorgcode")
	String s_taxorgcode, @RequestParam("s_taxdeptcode")
	String s_taxdeptcode, @RequestParam("s_taxmanagercode")
	String s_taxmanagercode, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		pageSize = "15";
		String sql = " select a.serial_id as serial_id,b.group_code as group_code,b.group_describe as group_describe,c.taxempcode as taxempcode,c.taxempname as taxempname,c.taxorgcode as taxorgcode from SYSTEM_USER2GROUP a,SYSTEM_USERGROUPS b,COD_TAXEMPCODE c where a.group_id = b.group_id and a.user_id = c.taxempcode ";
		if (!group_code_queryId.equals("") && group_code_queryId != null) {
			sql += " and b.group_code like '%" + group_code_queryId + "%'";
		}

		if (!s_taxorgsupcode.equals("") && s_taxorgsupcode != null) {
			sql += " and substring(c.taxorgcode,1,4) = '"
					+ s_taxorgsupcode.substring(0, 4) + "'";
		}

		if (!s_taxorgcode.equals("") && s_taxorgcode != null) {
			sql += " and substring(c.taxorgcode,1,6) = '"
					+ s_taxorgcode.substring(0, 6) + "'";
		}

		if (!s_taxdeptcode.equals("") && s_taxdeptcode != null) {
			sql += " and c.taxorgcode = '"
					+ s_taxdeptcode + "'";
		}
		
		if (!s_taxmanagercode.equals("") && s_taxmanagercode != null) {
			sql += " and c.taxempcode = '" + s_taxmanagercode + "'";
		}
		sql += " order by b.group_code,c.taxempcode ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("serial_id", Hibernate.STRING);
		attrMap.put("group_code", Hibernate.STRING);
		attrMap.put("group_describe", Hibernate.STRING);
		attrMap.put("taxempcode", Hibernate.STRING);
		attrMap.put("taxempname", Hibernate.STRING);
		attrMap.put("taxorgcode", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				Group2UserMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
		// System.out.println("--------" + jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/save")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String save(@RequestBody
	HashMap<String, List> map) {
		List<LinkedHashMap> groupList = (List<LinkedHashMap>) map
				.get("group_rows");
		List<LinkedHashMap> userList = (List<LinkedHashMap>) map
				.get("user_rows");
		for (int i = 0; i < groupList.size(); i++) {
			String group_id = (String) groupList.get(i).get("group_id");
			for (int j = 0; j < userList.size(); j++) {
				String taxempcode = (String) userList.get(j).get(
						"taxempcode");
				SystemUser2groupVO systemUser2groupVO = new SystemUser2groupVO();
				systemUser2groupVO.setSerial_id(UUIDGener.getUUID());
				systemUser2groupVO.setGroup_id(group_id);
				systemUser2groupVO.setUser_id(taxempcode);
				hibernateTemplate.save(systemUser2groupVO);
				hibernateTemplate.flush();
			}
		}
		return "00";
	}

	@RequestMapping(value = "/delete")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String delete(@RequestBody
	HashMap<String, List> map) {
		List<LinkedHashMap> group2userList = (List<LinkedHashMap>) map
				.get("group2user_rows");
		for (int i = 0; i < group2userList.size(); i++) {
			String serial_id = (String) group2userList.get(i).get(
					"serial_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemUser2groupVO where serial_id = '"
									+ serial_id + "'").executeUpdate();
			hibernateTemplate.flush();
		}
		return "00";
	}


}
