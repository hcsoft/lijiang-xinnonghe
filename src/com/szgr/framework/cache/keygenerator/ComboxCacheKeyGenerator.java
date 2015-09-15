package com.szgr.framework.cache.keygenerator;

import java.io.Serializable;

import org.aopalliance.intercept.MethodInvocation;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

import com.googlecode.ehcache.annotations.key.CacheKeyGenerator;

@Component("ComboxCacheKeyGenerator")
public class ComboxCacheKeyGenerator implements CacheKeyGenerator  {

	private static Logger log = Logger.getLogger(ComboxCacheKeyGenerator.class);
	
	public Serializable generateKey(MethodInvocation arg0) {
		String key = "";
//		System.out.println("--------------:"+arg0.getArguments().length + "---------------");
//		System.out.println("length--------------"+arg0.getArguments().length+ "---------------");
		for (Object arg:arg0.getArguments()) {
//			System.out.println("arg--------------"+arg+ "---------------");
		}
		key = arg0.getArguments()[0].toString();
//		System.out.println("--------------"+key+ "---------------");
		return key;
	}

	public Serializable generateKey(Object... arg0) {
		return null;
	}
}
