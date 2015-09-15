package com.szgr.framework.authority.services.authority_mgr.resource_mgr;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Hibernate;
import org.json.simple.JSONArray;
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
import com.szgr.framework.authority.vo.SystemResourcesVO;
import com.szgr.framework.pagination.PageUtil;
import com.szgr.framework.util.BeanDebugger;

@Controller
@RequestMapping("/ResourceMgrService")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class ResourceMgrService {

	@Autowired
	HibernateTemplate hibernateTemplate;

	@RequestMapping(value = "/save")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String save(ResourceMgrBean req) {

		// req.setRetStatus("00");
		BeanDebugger.printBeanInfo(req);
		SystemResourcesVO vo = new SystemResourcesVO();
		if (req.getResource_type().equals("00")) {// url 页面路径
			if (req.getIsFunc().equals("00")) {// 功能目录
				vo.setResource_id(UUIDGener.getUUID());
				vo.setResource_name(req.getBrandName() + "_目录");
				vo.setResource_type("url");
				vo.setResource_content("#");
				vo.setResouce_describe(req.getResouce_describe());
				vo.setEnabled(req.getEnabled());
				vo.setParent_menu_id("");
				vo.setLeaf_type("2");
				vo.setSort_str(req.getSort_str());
				vo.setSelfId(req.getBrandName() + "_id");
				vo.setParentId("#mainFuncId");
				vo.setIsDouble(req.getIsDouble());
				vo.setBgColor(req.getBgColor());
				vo.setTileType("icon");
				vo.setImgSrc(req.getImgSrc());
				vo.setBrandName(req.getBrandName());
				vo.setBrandCount("");
				vo.setBadgeColor("");
				vo.setTileHtml("");
				vo.setMenuIcon("");
				vo.setMenuUrl("");
				hibernateTemplate.save(vo);
				hibernateTemplate.flush();
			}
			if (req.getIsFunc().equals("01")) {// 功能菜单
				vo.setResource_id(UUIDGener.getUUID());
				vo.setResource_name(req.getBrandName() + "_菜单");
				vo.setResource_type("url");
				vo.setResource_content(req.getResource_content());
				vo.setResouce_describe(req.getResouce_describe());
				vo.setEnabled(req.getEnabled());
				vo.setParent_menu_id(req.getParent_menu_id());
				vo.setLeaf_type("3");
				vo.setSort_str(req.getSort_str());
				vo.setSelfId("");
				vo.setParentId("#subFuncId");
				vo.setIsDouble(req.getIsDouble());
				vo.setBgColor(req.getBgColor());
				vo.setTileType("icon");
				vo.setImgSrc(req.getImgSrc());
				vo.setBrandName(req.getBrandName());
				vo.setBrandCount("");
				vo.setBadgeColor("");
				vo.setTileHtml("");
				vo.setMenuIcon(req.getImgSrc());
				vo.setMenuUrl("url:" + req.getResource_content());
				hibernateTemplate.save(vo);
				hibernateTemplate.flush();
			}

		}
		if (req.getResource_type().equals("01")) {// .do功能路径
			vo.setResource_id(UUIDGener.getUUID());
			vo.setResource_name("");
			vo.setResource_type("url");
			vo.setResource_content(req.getResource_content());
			vo.setResouce_describe(req.getResouce_describe());
			vo.setEnabled(req.getEnabled());
			vo.setParent_menu_id("");
			vo.setLeaf_type("1");
			vo.setSort_str("");
			vo.setSelfId("");
			vo.setParentId("");
			vo.setIsDouble("");
			vo.setBgColor("");
			vo.setTileType("");
			vo.setImgSrc("");
			vo.setBrandName("");
			vo.setBrandCount("");
			vo.setBadgeColor("");
			vo.setTileHtml("");
			vo.setMenuIcon("");
			vo.setMenuUrl("");
			hibernateTemplate.save(vo);
			hibernateTemplate.flush();
		}
		return "00";
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
		// System.out.println("----------------" + pageSize);
		// System.out.println("----------------" + brandName);
		// System.out.println("----------------" + leaf_type);
		// System.out.println("----------------" + resource_content);
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
		sql += " order by leaf_type,brandName,resource_content";
		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("resource_id", Hibernate.STRING);
		attrMap.put("brandName", Hibernate.STRING);
		attrMap.put("leaf_type", Hibernate.STRING);
		attrMap.put("resource_content", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sql,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				ResourceMgrBo.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
//		System.out.println("--------" + jSONObject);
		return jSONObject;
	}

	@RequestMapping(value = "/getFuncMenuTops")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONArray getFuncMenuTops() {
		String hql = "from SystemResourcesVO vo where vo.enabled = '1' and vo.leaf_type = '2' order by vo.sort_str";
		List list = hibernateTemplate.find(hql);
		JSONArray arrays = new JSONArray();
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				SystemResourcesVO vo = (SystemResourcesVO) list.get(i);
				ResourceMgrComboBo bo = new ResourceMgrComboBo();
				bo.setValue(vo.getSelfId());
				bo.setText(vo.getBrandName());
				bo.setDesc(vo.getResouce_describe());
				arrays.add(bo);
			}

		}
		// String jsonString = JSONValue.toJSONString(l1);
		// System.out.println("-----------" + arrays);
		return arrays;
	}
	
	@RequestMapping(value = "/delete")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED)
	public String delete(@RequestBody
	HashMap<String, List> map) {
		List<LinkedHashMap> resourceList = (List<LinkedHashMap>) map
				.get("resource_rows");
		for (int i = 0; i < resourceList.size(); i++) {
			String resource_id = (String) resourceList.get(i).get(
					"resource_id");
			hibernateTemplate.getSessionFactory().getCurrentSession()
					.createQuery(
							"delete from SystemResourcesVO where resource_id = '"
									+ resource_id + "'").executeUpdate();
			hibernateTemplate.flush();
		}
		return "00";
	}
}
