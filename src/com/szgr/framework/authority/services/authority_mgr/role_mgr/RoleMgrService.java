package com.szgr.framework.authority.services.authority_mgr.role_mgr;

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
import com.szgr.framework.authority.vo.SystemRolesVO;
import com.szgr.framework.pagination.PageUtil;
import com.szgr.framework.util.BeanDebugger;

@Controller
@RequestMapping("/RoleMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class RoleMgrService {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/save")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String save(RoleMgrBean req) {

		// req.setRetStatus("00");
		BeanDebugger.printBeanInfo(req);
		SystemRolesVO vo = new SystemRolesVO();
		vo.setRole_id(UUIDGener.getUUID());
		vo.setRole_code(req.getRole_code());
		vo.setRole_describe(req.getRole_describe());
		vo.setEnabled(req.getEnabled());
		hibernateTemplate.save(vo);
		hibernateTemplate.flush();

		return "00";
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
	
	@RequestMapping(value = "/delete")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String delete(@RequestBody
	HashMap<String, List> map) {
		List<LinkedHashMap> roleList = (List<LinkedHashMap>) map
				.get("role_rows");
		for (int i = 0; i < roleList.size(); i++) {
			String role_id = (String) roleList.get(i).get(
					"role_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemRolesVO where role_id = '"
									+ role_id + "'").executeUpdate();
			hibernateTemplate.flush();
		}
		return "00";
	}
}
