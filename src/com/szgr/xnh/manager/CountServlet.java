package com.szgr.xnh.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.framework.authority.datarights.SystemUserAccessor;

@Controller
@RequestMapping("/Count")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class CountServlet {

	@Autowired
	HibernateTemplate hibernateTemplate;

	
	
	@RequestMapping(value = "/getnoticecount")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public Map getNoticecount(NoticeBvo req) {
		String taxempcode = SystemUserAccessor.getInstance().getTaxempcode();
		String sql = "select a.id as id ,a.title as title,a.content as content,a.datebegin as datebegin,a.dateend as dateend," +
				"a.to_orgcode as to_orgcode,a.opt_orgcode as opt_orgcode,a.opt_empcode as opt_empcode,a.optdate as optdate,a.valid as valid," +
				"b.readflag as readflag from xnh_notice a,xnh_notice2emp b  where  a.id = b.noticeid   ";
		sql = sql + "and b.empcode ='"+taxempcode+"' and readflag='00' ";
		
		sql = sql +" order by optdate";
		List ls = hibernateTemplate.getSessionFactory().getCurrentSession().createSQLQuery(sql).list();
		// System.out.println(jSONObject);a
		Map ret = new HashMap();
		ret.put("num", ls.size());
		return ret;
	}
	
}


