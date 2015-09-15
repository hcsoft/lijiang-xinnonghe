package com.szgr.framework.authority.services.authority_mgr.role2user_mgr;

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
import com.szgr.framework.authority.vo.SystemUser2roleVO;
import com.szgr.framework.pagination.PageUtil;

@Controller
@RequestMapping("/Role2UserMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class Role2UserMgrService {

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

	@RequestMapping(value = "/getRole2UserList")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getRole2UserList(@RequestParam("role_code_queryId")
	String role_code_queryId, @RequestParam("s_taxorgsupcode")
	String s_taxorgsupcode, @RequestParam("s_taxorgcode")
	String s_taxorgcode, @RequestParam("s_taxdeptcode")
	String s_taxdeptcode, @RequestParam("s_taxmanagercode")
	String s_taxmanagercode, @RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
//		System.out.println("----------------" + role_code_queryId);
//		System.out.println("----------------" + role_describe_queryId);
//		System.out.println("----------------" + brandName);
//		System.out.println("----------------" + leaf_type);
//		System.out.println("----------------" + resource_content);
		pageSize = "15";
		String sql = " select a.serial_id as serial_id,b.role_code as role_code,b.role_describe as role_describe,c.taxempcode as taxempcode,c.taxempname as taxempname,c.taxorgcode as taxorgcode from SYSTEM_USER2ROLE a,SYSTEM_ROLES b,COD_TAXEMPCODE c where a.role_id = b.role_id and a.user_id = c.taxempcode ";
		if (!role_code_queryId.equals("") && role_code_queryId != null) {
			sql += " and b.role_code like '%" + role_code_queryId + "%'";
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
		sql += " order by b.role_code,c.taxempcode ";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("serial_id", Hibernate.STRING);
		attrMap.put("role_code", Hibernate.STRING);
		attrMap.put("role_describe", Hibernate.STRING);
		attrMap.put("taxempcode", Hibernate.STRING);
		attrMap.put("taxempname", Hibernate.STRING);
		attrMap.put("taxorgcode", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				Role2UserMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
		// System.out.println("--------" + jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/save")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String save(@RequestBody
	HashMap<String, List> map) {
		List<LinkedHashMap> roleList = (List<LinkedHashMap>) map
				.get("role_rows");
		List<LinkedHashMap> userList = (List<LinkedHashMap>) map
				.get("user_rows");
		for (int i = 0; i < roleList.size(); i++) {
			String role_id = (String) roleList.get(i).get("role_id");
			for (int j = 0; j < userList.size(); j++) {
				String taxempcode = (String) userList.get(j).get(
						"taxempcode");
				SystemUser2roleVO systemUser2roleVO = new SystemUser2roleVO();
				systemUser2roleVO.setSerial_id(UUIDGener.getUUID());
				systemUser2roleVO.setRole_id(role_id);
				systemUser2roleVO.setUser_id(taxempcode);
				hibernateTemplate.save(systemUser2roleVO);
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
		List<LinkedHashMap> role2userList = (List<LinkedHashMap>) map
				.get("role2user_rows");
		for (int i = 0; i < role2userList.size(); i++) {
			String serial_id = (String) role2userList.get(i).get(
					"serial_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemUser2roleVO where serial_id = '"
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
