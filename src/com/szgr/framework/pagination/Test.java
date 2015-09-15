package com.szgr.framework.pagination;

import java.util.LinkedHashMap;
import java.util.Map;

import org.hibernate.Hibernate;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.framework.authority.services.authority_mgr.resource_mgr.TestVO;
import com.szgr.framework.cache.service.CacheService;

@Component
@RequestMapping("/Test")
public class Test {

	@Autowired
	HibernateTemplate hibernateTemplate;

//	private OptionProvider option;
	
	@RequestMapping(value = "/getItems")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public JSONObject getItems(@RequestParam("page")
	String currentPage, @RequestParam("rows")
	String pageSize) {
		

//		System.out.println("----------------" + currentPage);
//		System.out.println("----------------" + pageSize);

		String sss = " select resource_id  from SYSTEM_RESOURCES order by resource_id";

		Map<String, Object> attrMap = new LinkedHashMap<String, Object>();
		attrMap.put("resource_id", Hibernate.STRING);
		JSONObject jSONObject = PageUtil.paginateCustomNativeSqlJson(sss,
				Integer.parseInt(currentPage), Integer.parseInt(pageSize),
				TestVO.class, hibernateTemplate.getSessionFactory()
						.getCurrentSession(), attrMap);
		return jSONObject;
	}

}
