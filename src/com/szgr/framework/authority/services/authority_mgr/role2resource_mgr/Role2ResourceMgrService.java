package com.szgr.framework.authority.services.authority_mgr.role2resource_mgr;

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
import com.szgr.framework.authority.services.authority_mgr.resource_mgr.ResourceMgrBo;
import com.szgr.framework.authority.vo.SystemRole2resourceVO;
import com.szgr.framework.pagination.PageUtil;

@Controller
@RequestMapping("/Role2ResourceMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class Role2ResourceMgrService {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/getRoleList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getResourceList(@RequestParam("role_code_queryId")
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

	@RequestMapping(value = "/getRole2ResourceList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getRole2ResourceList(@RequestParam("role_code_queryId")
	String role_code_queryId, @RequestParam("role_describe_queryId")
	String role_describe_queryId, @RequestParam("brandName")
	String brandName, @RequestParam("leaf_type")
	String leaf_type, @RequestParam("resource_content")
	String resource_content, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		System.out.println("----------------" + role_code_queryId);
		System.out.println("----------------" + role_describe_queryId);
		System.out.println("----------------" + brandName);
		System.out.println("----------------" + leaf_type);
		System.out.println("----------------" + resource_content);
		pageSize = "15";
		String sql = " select a.serial_id as serial_id,b.role_code as role_code,b.role_describe as role_describe,c.brandName as brandName,c.leaf_type as leaf_type,c.resource_content as resource_content from SYSTEM_ROLE2RESOURCE a,SYSTEM_ROLES b,SYSTEM_RESOURCES c where a.role_id = b.role_id and a.resource_id = c.resource_id ";
		if (!role_code_queryId.equals("") && role_code_queryId != null) {
			sql += " and b.role_code like '%" + role_code_queryId + "%'";
		}

		if (!role_describe_queryId.equals("") && role_describe_queryId != null) {
			sql += " and b.role_describe like '%" + role_describe_queryId
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
		attrMap.put("role_code", Hibernate.STRING);
		attrMap.put("role_describe", Hibernate.STRING);
		attrMap.put("brandName", Hibernate.STRING);
		attrMap.put("leaf_type", Hibernate.STRING);
		attrMap.put("resource_content", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				Role2ResourceMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
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
		List<LinkedHashMap> roleList = (List<LinkedHashMap>) map
				.get("role_rows");
		List<LinkedHashMap> resourceList = (List<LinkedHashMap>) map
				.get("resource_rows");
		for (int i = 0; i < roleList.size(); i++) {
			String role_id = (String) roleList.get(i).get("role_id");
			for (int j = 0; j < resourceList.size(); j++) {
				String resource_id = (String) resourceList.get(j).get(
						"resource_id");
				SystemRole2resourceVO systemRole2resourceVO = new SystemRole2resourceVO();
				systemRole2resourceVO.setSerial_id(UUIDGener.getUUID());
				systemRole2resourceVO.setRole_id(role_id);
				systemRole2resourceVO.setResource_id(resource_id);
				hibernateTemplate.save(systemRole2resourceVO);
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
		List<LinkedHashMap> role2resourceList = (List<LinkedHashMap>) map
				.get("role2resource_rows");
		for (int i = 0; i < role2resourceList.size(); i++) {
			String serial_id = (String) role2resourceList.get(i).get(
					"serial_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemRole2resourceVO where serial_id = '"
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
