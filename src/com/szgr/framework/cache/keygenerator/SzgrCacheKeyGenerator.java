package com.szgr.framework.cache.keygenerator;

import java.io.Serializable;

import org.aopalliance.intercept.MethodInvocation;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

import com.googlecode.ehcache.annotations.key.CacheKeyGenerator;

@Component("SzgrCacheKeyGenerator")
public class SzgrCacheKeyGenerator implements CacheKeyGenerator  {

	private static Logger log = Logger.getLogger(SzgrCacheKeyGenerator.class);
	
	public Serializable generateKey(MethodInvocation arg0) {
		String key = arg0.getThis().getClass().getName()+"."+arg0.getMethod().getName();
		for (Object arg:arg0.getArguments()) {
			key+="#"+arg.toString();
		}
		log.debug("ehcache generateKey :"+key);
		System.out.println("ehcache generateKey :"+key);
		return key;
	}

	public Serializable generateKey(Object... arg0) {
		return null;
	}
}
