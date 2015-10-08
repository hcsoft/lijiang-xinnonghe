package com.szgr.framework.cache.options.code;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;

import com.googlecode.ehcache.annotations.Cacheable;
import com.googlecode.ehcache.annotations.KeyGenerator;
import com.szgr.framework.authority.datarights.OptionObject;

@Component("com.szgr.cache.options.code.CodeOption")
public class CodeOption implements ICodeOption {

	private static Logger log = Logger.getLogger(CodeOption.class);

	@Autowired
	private HibernateTemplate hibernateTemplate;

	/**
	 * 下拉列表的缓存数据
	 * 
	 * @param voClass
	 * @param where
	 * @return
	 */
	// new OptionObject
	@Cacheable(cacheName = "CODE_CACHE", keyGeneratorName = "ComboxCacheKeyGenerator")
	public List<OptionObject> getCodeVOComboxList(Class voClass,
			String keyfield, String valuefield, String where) {

		List<Object> list = new ArrayList<Object>();
		List<OptionObject> cacheList = new ArrayList<OptionObject>();
		StringBuilder hql = new StringBuilder();
		hql.append("from " + voClass.getSimpleName() + " vo where 1=1 ");
		if (where != null) {
			hql.append(where);
		}
		try {
			list = hibernateTemplate.find(hql.toString());
			for (Object voObject : list) {
				cacheList.add(new OptionObject(BeanUtils.getProperty(voObject,
						keyfield), BeanUtils.getProperty(voObject, valuefield),
						voObject));

			}
		} catch (Exception e) {
			e.printStackTrace();
			log.warn("取代码表错误:" + voClass.getSimpleName(), e);
		}
		log.warn("取代表缓存：" + voClass.getSimpleName() + "[" + list.size() + "]");
		return cacheList;
	}

	@Cacheable(cacheName = "CODE_CACHE", keyGeneratorName = "ComboxCacheKeyGenerator")
	public List<OptionObject> genCodeVOCache(String codetablename,
			String codekey, String codevalue, String where,Class voClass) {

		List<Object> list = new ArrayList<Object>();
		List<OptionObject> cacheList = new ArrayList<OptionObject>();
		StringBuilder hql = new StringBuilder();
		hql.append("from " + voClass.getSimpleName() + " vo where 1=1 ");
		if (where != null) {
			hql.append(where);
		}
		try {
			list = hibernateTemplate.find(hql.toString());
//			voClass.
			cacheList.add(new OptionObject("", "", voClass.newInstance()));
			for (Object voObject : list) {
				cacheList.add(new OptionObject(BeanUtils.getProperty(voObject,
						codekey), BeanUtils.getProperty(voObject, codevalue),
						voObject));

			}
		} catch (Exception e) {
			e.printStackTrace();
			log.warn("取代码表错误:" + voClass.getSimpleName(), e);
		}
		return cacheList;
	}

	/**
	 * 获取所有税务机关代码
	 * 
	 * @param voClass
	 * @param where
	 * @return
	 */
	@Cacheable(cacheName = "CODE_CACHE", keyGenerator = @KeyGenerator(name = "ListCacheKeyGenerator"))
	public List getTaxOrgsVOList() {

		List<Object> list = new ArrayList<Object>();
		StringBuffer hql = new StringBuffer(
				"from com.thtf.ynds.vo.CodTaxorgcodeVO order by taxorgcode");
		try {
			list = hibernateTemplate.find(hql.toString());
		} catch (Exception e) {
			log.warn("取代码表错误:CodTaxorgcodeVO", e);
		}
		log.warn("取代表缓存：CodTaxorgcodeVO" + "[" + list.size() + "]");
		return list;
	}

	/**
	 * 获取所有税务人员代码
	 * 
	 * @param voClass
	 * @param where
	 * @return
	 */
	@Cacheable(cacheName = "CODE_CACHE", keyGenerator = @KeyGenerator(name = "ListCacheKeyGenerator"))
	public List getTaxEmpsVOList() {

		List<Object> list = new ArrayList<Object>();
		StringBuffer hql = new StringBuffer(
				"from com.thtf.ynds.vo.CodTaxempcodeVO order by taxempcode");
		try {
			list = hibernateTemplate.find(hql.toString());
		} catch (Exception e) {
			log.warn("取代码表错误:CodTaxempcodeVO", e);
		}
		log.warn("取代表缓存：CodTaxempcodeVO" + "[" + list.size() + "]");
		return list;
	}

	
	
	public static void main(String[] args) {

	}
	
	

}
