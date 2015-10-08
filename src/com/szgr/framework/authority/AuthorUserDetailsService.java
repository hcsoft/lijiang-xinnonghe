package com.szgr.framework.authority;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sun.org.apache.commons.beanutils.BeanUtils;
import com.szgr.framework.authority.datarights.DataRightsBI;
import com.szgr.framework.authority.services.Authority.bean.AuthorityBean;
import com.szgr.framework.authority.services.Authority.bo.GrantedAuthorityBO;
import com.szgr.framework.authority.services.Authority.bo.RoleBO;
import com.thtf.ynds.vo.CodTaxempcodeVO;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

/**
 * 主体信息处理类
 * 
 * 
 */

@Controller
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class AuthorUserDetailsService implements UserDetailsService {
//	private static Logger log = Logger
//			.getLogger(AuthorUserDetailsService.class);
	private static org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AuthorUserDetailsService.class);

	@Autowired
	HibernateTemplate hibernateTemplate;

	/*
	 * (non-Javadoc) 获取主体信息(注:同时处理了自动登录数据)
	 * 
	 * @see org.springframework.security.core.userdetails.UserDetailsService#loadUserByUsername(java.lang.String)
	 */
	public UserDetails loadUserByUsername(String username)
			throws UsernameNotFoundException, DataAccessException {
		// TODO Auto-generated method stub
		// 封装用户信息
		UserInfo userInfo = new UserInfo();
		String trueUserName = username;
		String loginFlag = "";
		if (username.indexOf("&") != -1) {
			int index = username.indexOf("&");
			trueUserName = username.substring(0, index);
			loginFlag = username.substring(index + 1);
		}

		userInfo.setLogincode(trueUserName);
		// 生成服务请求bean
		AuthorityBean req = new AuthorityBean();
		req.setUserInfo(userInfo);
		AuthorityBean result = null;
		UserInfo returnUserInfo = null;
		try {
			result = (AuthorityBean) getUser(req);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.error("【获取服务时出现异常】", e);
			e.printStackTrace();
		}
		if (result != null && result.getUserInfo() != null) {
			returnUserInfo = result.getUserInfo();
			if (!"".equals(loginFlag)) {
				returnUserInfo.setPassword(loginFlag);
				returnUserInfo.setLoginFlag("autologin");
			}
			Set authoritieSet = new HashSet<GrantedAuthority>();
			// 弃除重复项
			for (Object temp : result.getRoles()) {
				authoritieSet.add(new GrantedAuthorityBO((RoleBO) temp));
			}
			returnUserInfo.setAuthorities(authoritieSet);
		} else {
			throw new UsernameNotFoundException("此用户不存在");
		}
		return returnUserInfo;
	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public AuthorityBean getUser(AuthorityBean req) {
		log.info("userinfo=================================="+req.getUserInfo().getUsername()+","+req.getUserInfo().getLogincode());
		AuthorityBean returnBean = new AuthorityBean();
		String LoginCode = req.getUserInfo().getLogincode();
		StringBuilder hql = new StringBuilder();
		// hql.append("from CodTaxempcodeVO user where ");
		// hql.append("user.valid='01' and user.logincode=:logincode");

		hql
				.append("select user,org from CodTaxempcodeVO user,CodTaxorgcodeVO org where ");
		hql
				.append("user.valid='01' and user.taxorgcode=org.taxorgcode and user.logincode=:logincode");
		UserInfo user = null;
		try {
			List userList = hibernateTemplate.findByNamedParam(hql.toString(),
					"logincode", LoginCode);
			if (!userList.isEmpty()) {
				Object[] tempuserinfo = (Object[]) userList.get(0);
				CodTaxempcodeVO tempuser = (CodTaxempcodeVO) tempuserinfo[0];
				user = new UserInfo();
				BeanUtils.copyProperties(user, tempuser);
				CodTaxorgcodeVO orgvo = new CodTaxorgcodeVO();
				BeanUtils.copyProperties(orgvo,
						(CodTaxorgcodeVO) tempuserinfo[1]);
				user.setCodTaxorgcodeVO(orgvo);
				user.setOrgName(orgvo.getTaxorgname());

				Session session = hibernateTemplate.getSessionFactory()
						.getCurrentSession();
				// 获取数据权限
				List rightlist = DataRightsBI.loadDataRightsFromDB(session,
						orgvo, tempuser.getTaxempcode());
				user.setUserrights(rightlist);
				user.printallrights();
				// ----------------------------------
				// 10m:TAX_MANAGER_MG:taxorgcode = '5323260000'
				// 15s:TAX_MANAGER_SELECT:taxorgcode like '532326%'
				// 20m:TAX_LEVY_MG:taxorgcode = '5323260000'
				// 25s:TAX_LEVY_SELECT:taxorgcode like '532326%'
				// 30m:FEE_MANAGER_MG:taxorgcode = '5323260000'
				// 35s:FEE_MANAGER_SELECT:taxorgcode like '532326%'
				// 40m:FEE_LEVY_MG:taxorgcode = '5323260000'
				// 45s:FEE_LEVY_SELECT:taxorgcode like '532326%'
				// 50m:INV_MG:taxorgcode = '5323260000'
				// 55s:INV_SELECT:taxorgcode like '532326%'
				// 60m:POL_MG:taxorgcode = '5323260000'
				// 65s:POL_SELECT:taxorgcode like '532326%'
				// 70m:TAX_ACC_MG:taxorgcode = '5323260000'
				// 75s:TAX_ACC_SELECT:taxorgcode like '532326%'
				// 80m:FEE_ACC_MG:taxorgcode = '5323260000'
				// 85s:FEE_ACC_SELECT:taxorgcode like '532326%'
				// ----------------------------------
				returnBean.setUserInfo(user);
				returnBean.setRoles(this.getAuthorityRoles(user));
		    	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest(); 
		        HttpSession httpSession = request.getSession();
//		        httpSession.removeAttribute("userInfoSession");
				httpSession.setAttribute("userInfoSession", user);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("【检验当前用户是否存在异常】", e);
		}
		return returnBean;
	}

	/**
	 * 当前用户主体信息存在的话，获取用户对应的角色信息
	 * 
	 * @param user
	 * @return
	 */
	protected List<RoleBO> getAuthorityRoles(UserInfo user) {
		String allString = "select new com.szgr.framework.authority.services.Authority.bo.RoleBO(role.role_id,role.role_code) ";
		StringBuilder hql1 = new StringBuilder();
		StringBuilder hql2 = new StringBuilder();
		hql1.append(allString);
		hql1.append(" from SystemRolesVO role, SystemUser2roleVO u2r where ");
		hql1
				.append("role.enabled='1' and role.role_id=u2r.role_id and u2r.user_id=:userId");
		hql2.append(allString);
		hql2
				.append(" from SystemRolesVO role, SystemGroup2roleVO g2r ,SystemUser2groupVO u2g where ");
		hql2
				.append("role.enabled='1' and role.role_id=g2r.role_id and g2r.group_id=u2g.group_id and u2g.user_id =:user_id ");
		List tempRoles = new ArrayList();
		try {
			// 通过用户id来获取用户角色
			List userRoles = hibernateTemplate.findByNamedParam(
					hql1.toString(), "userId", user.getTaxempcode());
			tempRoles.addAll(userRoles);
			// 通过用户组关联来获取用户角色
			List groupRoles = hibernateTemplate.findByNamedParam(hql2
					.toString(), "user_id", user.getTaxempcode());
			tempRoles.addAll(groupRoles);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("【获取用户对应的角色信息出现异常】", e);
		}

		return tempRoles;
	}

}
