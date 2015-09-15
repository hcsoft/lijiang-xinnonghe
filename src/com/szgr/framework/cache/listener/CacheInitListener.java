package com.szgr.framework.cache.listener;

import java.util.List;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import com.szgr.framework.cache.options.code.ICodeOption;
import com.szgr.framework.util.SpringContextUtil;

public class CacheInitListener implements ServletContextListener {
	// @Resource(name="com.szgr.cache.options.code.CodeOption")
	// private ICodeOption codeOption;

	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub

	}

	public void contextInitialized(ServletContextEvent arg0) {
//		ICodeOption codeOption = (ICodeOption) SpringContextUtil
//				.getApplicationContext().getBean(
//						"com.szgr.cache.options.code.CodeOption");
//		System.out.println("-------------" + codeOption);
//		List codTaxcodeVOList = codeOption.getCodeVOComboxList(
//				CodTaxcodeVO.class, " and 1=1 ");
//		List codHouseusecodeVOList = codeOption.getCodeVOComboxList(
//				CodHouseusecodeVO.class, " and 1=1 ");
//		CacheManager cm = (CacheManager) SpringContextUtil
//				.getBean("cacheManager");
//		Cache cache = cm.getCache("CODE_CACHE");
//		cache.put(new Element("key1", "values1"));
//		System.out.println("-------------" + codTaxcodeVOList.size());
//		System.out.println("-------------" + codHouseusecodeVOList.size());
		
	}
}
