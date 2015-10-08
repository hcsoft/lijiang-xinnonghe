package com.szgr.framework.cache.service;

import java.util.List;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;

import org.json.simple.JSONArray;

import com.szgr.framework.authority.datarights.OptionObject;
import com.szgr.framework.authority.options.CommonOption;
import com.szgr.framework.util.SpringContextUtil;

public class CacheService {

	public static List<OptionObject> getCachelist(String codetablename) {

		CacheManager cm = (CacheManager) SpringContextUtil
				.getBean("cacheManager");
		Cache cache = cm.getCache("CODE_CACHE");
		List<OptionObject> cacheList = (List) cache.get(codetablename)
				.getObjectValue();
		return cacheList;
	}
	
	public static JSONArray convertOptionObject2CommonOption(List<OptionObject> optionObjectList){
		JSONArray retJSONArray = new JSONArray();
		for(OptionObject o : optionObjectList){
			CommonOption co = new CommonOption();
			co.setKey(o.getKey());
			co.setValue(o.getValue());
			co.setKeyvalue(o.getKeyvalue());
			retJSONArray.add(co);
//			System.out.println("-------------" + o.getKeyvalue() + "-------------");
		}
		return retJSONArray;
		
	}
}
