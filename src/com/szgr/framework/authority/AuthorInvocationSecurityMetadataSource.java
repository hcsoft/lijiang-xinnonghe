package com.szgr.framework.authority;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.security.web.util.AntUrlPathMatcher;
import org.springframework.security.web.util.UrlMatcher;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.szgr.framework.authority.services.Authority.bean.AuthorityBean;
import com.szgr.framework.authority.services.Authority.bo.Url2RoleBO;

/**
 * 
 * 此类在初始化时，应该取到所有资源及其对应角色的定义
 * 
 * 
 */
@Controller
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class AuthorInvocationSecurityMetadataSource implements
		FilterInvocationSecurityMetadataSource {
	private static Logger log = Logger
			.getLogger(AuthorInvocationSecurityMetadataSource.class);
	
	@Autowired
	HibernateTemplate hibernateTemplate;
	
	private UrlMatcher urlMatcher = new AntUrlPathMatcher();;
	private static Map<String, Collection<ConfigAttribute>> resourceMap = null;

	public AuthorInvocationSecurityMetadataSource() {

	}

	/**
	 * 加载资源
	 */
	private void loadResourceDefine() {
		AuthorityBean req = new AuthorityBean();
		AuthorityBean result = null;
		try {
			result = (AuthorityBean) getUrlMetadataSource(req);
		} catch (Exception e) {
			log.error("【获取服务时出现异常】", e);
			e.printStackTrace();
		}
		resourceMap = new HashMap<String, Collection<ConfigAttribute>>();
		if (result != null) {
			for (Url2RoleBO temp : result.getUrl2Roles()) {
				Collection tempCollection = resourceMap.get(temp.getUrl());
				if (tempCollection == null) {
					Set urlRoleSet = new HashSet<String>();
					urlRoleSet.add(new SecurityConfig(temp.getRoleStr()));
					resourceMap.put(temp.getUrl(), urlRoleSet);
					continue;
				}
				tempCollection.add(temp.getRoleStr());
			}
		}
	}

	public Collection<ConfigAttribute> getAllConfigAttributes() {
		return null;
	}

	public Collection<ConfigAttribute> getAttributes(Object paramObject)
			throws IllegalArgumentException {
		loadResourceDefine();// 加载系统资源
		String urlString = ((FilterInvocation) paramObject).getRequestUrl();
		urlString = urlString.substring(0,
				urlString.lastIndexOf("?") == -1 ? urlString.length()
						: urlString.lastIndexOf("?"));
		Iterator<String> it = resourceMap.keySet().iterator();
		while (it.hasNext()) {
			String nextURL = it.next();
			if (urlMatcher.pathMatchesUrl(urlString, nextURL)) {
				return resourceMap.get(nextURL);
			}
		}
		return new ArrayList<ConfigAttribute>();
	}

	public boolean supports(Class<?> paramClass) {
		// TODO Auto-generated method stub
		return true;
	}
	
	/**
	 * 加载权限资源
	 */
	public AuthorityBean getUrlMetadataSource(AuthorityBean req) {
		HttpSession session = getSession();
		if (session.getAttribute("loadResourceDefine") != null) {
			return (AuthorityBean) session.getAttribute("loadResourceDefine");
		}
		System.out.println("======================================11111");
		AuthorityBean returnBean = new AuthorityBean();
		StringBuilder hql = new StringBuilder();
		hql.append("select new com.szgr.framework.authority.services.Authority.bo.Url2RoleBO(res.resource_content,role.role_code) from ");
		hql.append("SystemResourcesVO res,SystemRolesVO role,SystemRole2resourceVO r2r where ");
		hql.append("res.resource_id=r2r.resource_id and r2r.role_id=role.role_id and res.enabled='1' and role.enabled='1' ");
		hql.append("and (res.resource_type='url' or res.leaf_type='2')");
		List res2RoleList = null;
		try {
			res2RoleList = hibernateTemplate.find(hql.toString());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("【加载权限资源信息出现异常】", e);
		}
		returnBean.setUrl2Roles(res2RoleList);
		session.setAttribute("loadResourceDefine", returnBean);
		return returnBean;
	}
	
    public HttpSession getSession() {        
    	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest(); 
        HttpSession httpSession = request.getSession();
        return httpSession; 
    }
}
