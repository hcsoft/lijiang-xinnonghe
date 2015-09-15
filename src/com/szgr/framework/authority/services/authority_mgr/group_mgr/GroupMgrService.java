package com.szgr.framework.authority.services.authority_mgr.group_mgr;

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
import com.szgr.framework.authority.vo.SystemUsergroupsVO;
import com.szgr.framework.pagination.PageUtil;
import com.szgr.framework.util.BeanDebugger;

@Controller
@RequestMapping("/GroupMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class GroupMgrService {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/save")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String save(GroupMgrBean req) {

		// req.setRetStatus("00");
		BeanDebugger.printBeanInfo(req);
		SystemUsergroupsVO vo = new SystemUsergroupsVO();
		vo.setGroup_id(UUIDGener.getUUID());
		vo.setGroup_code(req.getGroup_code());
		vo.setGroup_describe(req.getGroup_describe());
		vo.setGroup_type("00");
		vo.setEnabled(req.getEnabled());
		hibernateTemplate.save(vo);
		hibernateTemplate.flush();

		return "00";
	}

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
	
	@RequestMapping(value = "/delete")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String delete(@RequestBody
	HashMap<String, List> map) {
		List<LinkedHashMap> groupList = (List<LinkedHashMap>) map
				.get("group_rows");
		for (int i = 0; i < groupList.size(); i++) {
			String group_id = (String) groupList.get(i).get(
					"group_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemUsergroupsVO where group_id = '"
									+ group_id + "'").executeUpdate();
			hibernateTemplate.flush();
		}
		return "00";
	}
}
