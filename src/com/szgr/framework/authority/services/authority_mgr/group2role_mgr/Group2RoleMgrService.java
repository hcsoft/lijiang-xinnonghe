package com.szgr.framework.authority.services.authority_mgr.group2role_mgr;

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
import com.szgr.framework.authority.services.authority_mgr.role_mgr.RoleMgrBo;
import com.szgr.framework.authority.vo.SystemGroup2roleVO;
import com.szgr.framework.pagination.PageUtil;

@Controller
@RequestMapping("/Group2RoleMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class Group2RoleMgrService {

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

		if (!group_describe_queryId.equals("")
				&& group_describe_queryId != null) {
			sql += " and group_describe like '%" + group_describe_queryId
					+ "%'";
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

	@RequestMapping(value = "/getRoleList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getRoleList(@RequestParam("role_code_queryId")
	String role_code_queryId, @RequestParam("role_describe_queryId")
	String role_describe_queryId, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		pageSize = "15";
		String sql = " select role_id ,role_code,role_describe from SYSTEM_ROLES where 1=1 ";

		if (!role_code_queryId.equals("") && role_code_queryId != null) {
			sql += " and role_code like '%" + role_code_queryId + "%'";
		}

		if (!role_describe_queryId.equals("") && role_describe_queryId != null) {
			sql += " and role_describe like '%" + role_describe_queryId + "%'";
		}

		sql += " order by role_code,role_describe ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("role_id", Hibernate.STRING);
		attrMap.put("role_code", Hibernate.STRING);
		attrMap.put("role_describe", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				RoleMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
		// System.out.println("--------" + jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/getGroup2RoleList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getGroup2RoleList(@RequestParam("group_code_queryId")
	String group_code_queryId, @RequestParam("role_code_queryId")
	String role_code_queryId, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		pageSize = "15";
		String sql = " select a.serial_id as serial_id,b.group_code as group_code,b.group_describe as group_describe,c.role_code as role_code,c.role_describe as role_describe from SYSTEM_GROUP2ROLE a,SYSTEM_USERGROUPS b,SYSTEM_ROLES c where a.group_id = b.group_id and a.role_id = c.role_id ";
		if (!group_code_queryId.equals("") && group_code_queryId != null) {
			sql += " and b.group_code like '%" + group_code_queryId + "%'";
		}

		if (!role_code_queryId.equals("") && role_code_queryId != null) {
			sql += " and c.role_code like '%" + role_code_queryId + "%'";
		}

		sql += " order by b.group_code,c.role_code ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("serial_id", Hibernate.STRING);
		attrMap.put("group_code", Hibernate.STRING);
		attrMap.put("group_describe", Hibernate.STRING);
		attrMap.put("role_code", Hibernate.STRING);
		attrMap.put("role_describe", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				Group2RoleMgrBo.class, hibernateTemplate.getSessionFactory()
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
		List<LinkedHashMap> roleList = (List<LinkedHashMap>) map
				.get("role_rows");
		for (int i = 0; i < groupList.size(); i++) {
			String group_id = (String) groupList.get(i).get("group_id");
			for (int j = 0; j < roleList.size(); j++) {
				String role_id = (String) roleList.get(j).get("role_id");
				SystemGroup2roleVO systemGroup2roleVO = new SystemGroup2roleVO();
				systemGroup2roleVO.setSerial_id(UUIDGener.getUUID());
				systemGroup2roleVO.setGroup_id(group_id);
				systemGroup2roleVO.setRole_id(role_id);
				hibernateTemplate.save(systemGroup2roleVO);
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
		List<LinkedHashMap> group2roleList = (List<LinkedHashMap>) map
				.get("group2role_rows");
		for (int i = 0; i < group2roleList.size(); i++) {
			String serial_id = (String) group2roleList.get(i).get("serial_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemGroup2roleVO where serial_id = '"
									+ serial_id + "'").executeUpdate();
			hibernateTemplate.flush();
		}
		return "00";
	}

}
