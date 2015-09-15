package com.szgr.framework.core;


import javax.sql.DataSource;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Service;

@Service
public class ApplicationContextUtils implements ApplicationContextAware{

	private static final String DATASOURCE_NAME = "dataSource";
	private static final String HIBERNATE_TEMPLATE = "hibernateTemplate";
	private static ApplicationContext ac;
	
	private static JdbcTemplate jdbcTemplate;
	
	private static HibernateTemplate hibernateTemplate;
	
	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
         ac = applicationContext;
         try{
             jdbcTemplate =  ac.getBean(JdbcTemplate.class);
         }catch(NoSuchBeanDefinitionException ex){
        	 jdbcTemplate = null;
         }
         if(jdbcTemplate == null ){
        	 DataSource ds = (DataSource)ac.getBean(DATASOURCE_NAME);
        	 jdbcTemplate = new JdbcTemplate(ds);
         }
         try{
        	 hibernateTemplate = (HibernateTemplate)ac.getBean(HIBERNATE_TEMPLATE);
         }catch(NoSuchBeanDefinitionException ex){
        	 hibernateTemplate = null;
         }
	}
	public static ApplicationContext getApplicationContext(){
		return ac;
	}
	public static JdbcTemplate getJdbcTemplate(){
		return jdbcTemplate;
	}
	public static HibernateTemplate getHibernateTemplate(){
		return hibernateTemplate;
	}

}
