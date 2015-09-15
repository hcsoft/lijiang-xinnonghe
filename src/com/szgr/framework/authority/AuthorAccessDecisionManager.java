package com.szgr.framework.authority;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.FilterInvocation;

import com.szgr.framework.authority.services.Authority.bean.AuthorityBean;
import com.szgr.framework.authority.services.Authority.bo.UrlCheckBO;

/**
 * 权限决策管理器
 * 
 */
public class AuthorAccessDecisionManager implements AccessDecisionManager {
	private static Logger log = Logger
			.getLogger(AuthorAccessDecisionManager.class);

	@Autowired
	HibernateTemplate hibernateTemplate;

	/*
	 * 决策方法 (non-Javadoc)
	 * 
	 * @see org.springframework.security.access.AccessDecisionManager#decide(org.springframework.security.core.Authentication,
	 *      java.lang.Object, java.util.Collection)
	 */
	public void decide(Authentication authentication, Object paramObject,
			Collection<ConfigAttribute> configAttributes)
			throws AccessDeniedException, InsufficientAuthenticationException {
		String currentUrl = ((FilterInvocation) paramObject).getRequestUrl();
		try {
			System.out.println("当前资源:[" + currentUrl + "]");
			for (Object ca : configAttributes) {
				String needRole = ca.toString();
				System.out.println("当前资源必需的角色:[" + needRole + "]");
			}
			String roles = "";
			for (GrantedAuthority ga : authentication.getAuthorities()) {
				roles = roles + ga.getAuthority() + ",";
			}
			if (roles.length() <= 0) {
				System.out.println("当前登录人员没有绑定任何角色");
			} else {
				System.out.println("当前登录人员的角色:["
						+ roles.substring(0, roles.length() - 1) + "]");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		if (configAttributes == null) {
			return;
		}
		// 当前访问的url
		// String currentUrl = ((FilterInvocation) paramObject).getRequestUrl();
		UserInfo currentPrincipal = null;
		// ---------------获取主体信息演示start-------------------
		Object principal = SecurityContextHolder.getContext()
				.getAuthentication().getPrincipal();
		if (principal instanceof UserInfo) {
			currentPrincipal = (UserInfo) principal;

			// 模块编码
			// String moduleAuth = parseCurrentModule(currentUrl);
			// currentPrincipal.setModuleAuth(moduleAuth);

			// System.out.println(((UserInfo) principal).getUsername());
		} else {
			// System.out.println(principal.toString());
		}
		System.out.println("当前登录人员信息:" + currentPrincipal);
		// ---------------获取主体信息演示end-------------------

		// 通过当前用户所对应角色来验证权限
		Iterator<ConfigAttribute> iterator = configAttributes.iterator();
		for (Object ca : configAttributes) {
			String needRole = ca.toString();
			for (GrantedAuthority ga : authentication.getAuthorities()) {
				if (needRole.equals(ga.getAuthority())) {
					return;
				}
			}
		}
		AuthorityBean req = new AuthorityBean();
		AuthorityBean result = null;

		// 主体信息
		Object userInfo = authentication.getPrincipal();
		String userId = null;
		if (principal instanceof UserInfo) {
			userId = ((UserInfo) userInfo).getTaxempcode();
		}
		try {
			UrlCheckBO urlCheck = new UrlCheckBO();
			urlCheck.setUrl(currentUrl);
			// 如果通过角色不能决定当前用户是否对当前资源有访问权限，则通过验证当前用户有没有直接关联的资源
			if (userId != null) {
				urlCheck.setId(userId);
				urlCheck.setAccessUserId(true);
				req.setUrlCheck(urlCheck);
				result = (AuthorityBean) checkUserAccess(req);
				if (result != null && result.getUrlCheck().isAccess()) {
					return;
				}
			}
			// 如果通过角色不能决定当前用户是否对当前资源有访问权限，则通过验证当前用户组有没有直接关联的资源
			if (userId != null) {
				urlCheck.setId(userId);
				urlCheck.setAccessUserId(false);
				req.setUrlCheck(urlCheck);
				result = (AuthorityBean) checkUserAccess(req);
				if (result != null && result.getUrlCheck().isAccess()) {
					return;
				}
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.error("【获取服务时出现异常】", e);
			e.printStackTrace();
		}
		throw new AccessDeniedException("noRight");
	}

	public boolean supports(ConfigAttribute paramConfigAttribute) {
		// TODO Auto-generated method stub
		return true;
	}

	public boolean supports(Class<?> paramClass) {
		// TODO Auto-generated method stub
		return true;
	}

	/**
	 * 通过用户ID或者组ID来验证当前用户是否可以访问当前资源
	 */
	public AuthorityBean checkUserAccess(AuthorityBean req) {
		AuthorityBean returnBean = new AuthorityBean();
		UrlCheckBO urlCheck = new UrlCheckBO();
		StringBuilder hql = new StringBuilder();
		hql.append("from SystemResourcesVO res,");
		if (req.getUrlCheck().isAccessUserId()) {
			hql.append("SystemUser2resourceVO u2r where ");
			hql
					.append("u2r.user_id=:user_id and u2r.resource_id=res.resource_id and ");
		} else {
			hql
					.append("SystemGroup2resourceVO g2r,SystemUser2groupVO u2g where ");
			hql.append("g2r.resource_id=res.resource_id and ");
			hql
					.append("g2r.group_id=u2g.group_id and u2g.user_id=:user_id and ");
		}

		hql.append("res.resource_content like '%" + req.getUrlCheck().getUrl()
				+ "'");
		List user2Res = null;
		try {
			user2Res = hibernateTemplate.findByNamedParam(hql.toString(),
					"user_id", req.getUrlCheck().getId());

			if (!user2Res.isEmpty()) {
				urlCheck.setAccess(true);
			} else {
				urlCheck.setAccess(false);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("【获取用户对应的角色信息出现异常】", e);
		}
		returnBean.setUrlCheck(urlCheck);
		return returnBean;
	}
}
