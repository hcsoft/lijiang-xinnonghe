package com.szgr.framework.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 获取spring上下文的帮助类，兼容了容器环境和直接运行环境，方便开发和测试
 *
 */
public class SpringContextUtil  implements ApplicationContextAware {
	
	/**
	 * 上下文
	 */
	static ApplicationContext applicationContext; 
	
	public static Object getBean(String name){
		return getApplicationContext().getBean(name);
	}

	public static Object getBean(Class clazz){
		return getApplicationContext().getBean(clazz);
	}
	
	public static void main(String[] args){
		System.out.println(SpringContextUtil.getApplicationContext());
	}

	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		SpringContextUtil.applicationContext = applicationContext;
	}

	public static ApplicationContext getApplicationContext() {
		if( applicationContext == null){
			applicationContext = new ClassPathXmlApplicationContext("spring.xml");
		} 
		return applicationContext;
	}
}
