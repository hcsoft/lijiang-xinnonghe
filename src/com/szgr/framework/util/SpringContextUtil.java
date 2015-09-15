package com.szgr.framework.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * ��ȡspring�����ĵİ����࣬����������������ֱ�����л��������㿪���Ͳ���
 *
 */
public class SpringContextUtil  implements ApplicationContextAware {
	
	/**
	 * ������
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
