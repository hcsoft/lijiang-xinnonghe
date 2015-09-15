package com.szgr.framework.authority.services.authority_mgr.group2resource_mgr;

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
import com.szgr.framework.authority.services.authority_mgr.group_mgr.GroupMgrBo;
import com.szgr.framework.authority.services.authority_mgr.resource_mgr.ResourceMgrBo;
import com.szgr.framework.authority.vo.SystemGroup2resourceVO;
import com.szgr.framework.pagination.PageUtil;

@Controller
@RequestMapping("/Group2ResourceMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class Group2ResourceMgrService {

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

	@RequestMapping(value = "/getResourceList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getResourceList(@RequestParam("brandName")
	String brandName, @RequestParam("leaf_type")
	String leaf_type, @RequestParam("resource_content")
	String resource_content, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		pageSize = "15";
		String sql = " select resource_id ,brandName,leaf_type,resource_content from SYSTEM_RESOURCES where 1=1 ";
		if (!brandName.equals("") && brandName != null) {
			sql += " and brandName like '%" + brandName + "%'";
		}

		if (!leaf_type.equals("") && leaf_type != null) {
			sql += " and leaf_type = '" + leaf_type + "'";
		}

		if (!resource_content.equals("") && resource_content != null) {
			sql += " and resource_content like '%" + resource_content + "%'";
		}
		sql += " order by leaf_type,brandName,resource_content ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("resource_id", Hibernate.STRING);
		attrMap.put("brandName", Hibernate.STRING);
		attrMap.put("leaf_type", Hibernate.STRING);
		attrMap.put("resource_content", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				ResourceMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
		// System.out.println("--------" + jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/getGroup2ResourceList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getGroup2ResourceList(@RequestParam("group_code_queryId")
	String group_code_queryId, @RequestParam("group_describe_queryId")
	String group_describe_queryId, @RequestParam("brandName")
	String brandName, @RequestParam("leaf_type")
	String leaf_type, @RequestParam("resource_content")
	String resource_content, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		pageSize = "15";
		String sql = " select a.serial_id as serial_id,b.group_code as group_code,b.group_describe as group_describe,c.brandName as brandName,c.leaf_type as leaf_type,c.resource_content as resource_content from SYSTEM_GROUP2RESOURCE a,SYSTEM_USERGROUPS b,SYSTEM_RESOURCES c where a.group_id = b.group_id and a.resource_id = c.resource_id ";
		if (!group_code_queryId.equals("") && group_code_queryId != null) {
			sql += " and b.group_code like '%" + group_code_queryId + "%'";
		}

		if (!group_describe_queryId.equals("")
				&& group_describe_queryId != null) {
			sql += " and b.group_describe like '%" + group_describe_queryId
					+ "%'";
		}

		if (!brandName.equals("") && brandName != null) {
			sql += " and c.brandName like '%" + brandName + "%'";
		}

		if (!leaf_type.equals("") && leaf_type != null) {
			sql += " and c.leaf_type = '" + leaf_type + "'";
		}

		if (!resource_content.equals("") && resource_content != null) {
			sql += " and c.resource_content like '%" + resource_content + "%'";
		}
		sql += " order by leaf_type,brandName,c.resource_content ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("serial_id", Hibernate.STRING);
		attrMap.put("group_code", Hibernate.STRING);
		attrMap.put("group_describe", Hibernate.STRING);
		attrMap.put("brandName", Hibernate.STRING);
		attrMap.put("leaf_type", Hibernate.STRING);
		attrMap.put("resource_content", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				Group2ResourceMgrBo.class, hibernateTemplate
						.getSessionFactory().getCurrentSession(), attrMap);
		// System.out.println("--------" + jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/save")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String save(@RequestBody
	HashMap<String, List> map) {

		// System.out.println("----------------" + map);
		// System.out.println("----------------" + map.get("role_rows"));
		// System.out.println("----------------" + map.get("resource_rows"));
		// System.out.println("----------------"
		// + ((List) map.get("role_rows")).size());
		// System.out.println("----------------"
		// + ((List) map.get("resource_rows")).size());
		List<LinkedHashMap> groupList = (List<LinkedHashMap>) map
				.get("group_rows");
		List<LinkedHashMap> resourceList = (List<LinkedHashMap>) map
				.get("resource_rows");
		for (int i = 0; i < groupList.size(); i++) {
			String group_id = (String) groupList.get(i).get("group_id");
			for (int j = 0; j < resourceList.size(); j++) {
				String resource_id = (String) resourceList.get(j).get(
						"resource_id");
				SystemGroup2resourceVO systemGroup2resourceVO = new SystemGroup2resourceVO();
				systemGroup2resourceVO.setSerial_id(UUIDGener.getUUID());
				systemGroup2resourceVO.setGroup_id(group_id);
				systemGroup2resourceVO.setResource_id(resource_id);
				hibernateTemplate.save(systemGroup2resourceVO);
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
		List<LinkedHashMap> group2resourceList = (List<LinkedHashMap>) map
				.get("group2resource_rows");
		for (int i = 0; i < group2resourceList.size(); i++) {
			String serial_id = (String) group2resourceList.get(i).get(
					"serial_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemGroup2resourceVO where serial_id = '"
									+ serial_id + "'").executeUpdate();
			hibernateTemplate.flush();
		}
		return "00";
	}

	// @RequestMapping(value = "/delete")
	// @ResponseBody
	// @Transactional(propagation = Propagation.REQUIRED)
	// public String delete(@RequestParam("role_id")
	// String role_id) {
	// hibernateTemplate.getSessionFactory().getCurrentSession().createQuery(
	// "delete from SystemRolesVO where role_id = '" + role_id + "'")
	// .executeUpdate();
	// hibernateTemplate.flush();
	// return "00";
	// }
}
