package com.szgr.framework.util;

import org.springframework.orm.hibernate3.HibernateTemplate;

 
 

public class HibernateTemplateUtil {
	/**
	 * 获取session
	 * 
	 * @return
	 */
	public static HibernateTemplate getTemplate() {
		HibernateTemplate result = (HibernateTemplate)SpringContextUtil.getApplicationContext().getBean(
				"hibernateTemplate");
		System.out.println(result);
		return result;
	};

	/**
	 * 获取session
	 * 
	 * @return
	 */
	public static HibernateTemplate getTemplate(String templateName) {
		HibernateTemplate result = (HibernateTemplate) SpringContextUtil
				.getBean(templateName);
		System.out.println(result);
		return result;
	}
 
}
