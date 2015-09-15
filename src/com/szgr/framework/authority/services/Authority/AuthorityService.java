package com.szgr.framework.authority.services.Authority;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun.org.apache.commons.beanutils.BeanUtils;
import com.szgr.framework.authority.UserInfo;
import com.szgr.framework.authority.services.Authority.bean.AuthorityBean;
import com.szgr.framework.authority.services.Authority.bo.RoleBO;
import com.szgr.framework.authority.services.Authority.bo.UrlCheckBO;
import com.thtf.ynds.vo.CodTaxempcodeVO;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

/**
 * 权限控制服务控件 ${module.cnModuleName}
 * 
 * @version 1.0 Created by SourceGenerate.
 */
@Controller
@RequestMapping("/authorityService")
@Component
@Scope("prototype")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class AuthorityService {
	private static Logger log = Logger.getLogger(AuthorityService.class);
	@Autowired
	HibernateTemplate hibernateTemplate;

	/**
	 * 检验当前用户是否存在
	 * 
	 */
	@RequestMapping(value = "/getUser")
	@ResponseBody
	public AuthorityBean getUser(@RequestBody AuthorityBean req) {
		AuthorityBean returnBean = new AuthorityBean();
		String LoginCode = req.getUserInfo().getLogincode();
		StringBuilder hql = new StringBuilder();
//		hql.append("from CodTaxempcodeVO user where ");
//		hql.append("user.valid='01' and user.logincode=:logincode");
		
		hql.append("select user,org from CodTaxempcodeVO user,CodTaxorgcodeVO org where ");
		hql.append("user.valid='01' and user.taxorgcode=org.taxorgcode and user.logincode=:logincode");
		UserInfo user = null;
		try {
			List userList = hibernateTemplate.findByNamedParam(hql.toString(),"logincode",LoginCode);
			if(!userList.isEmpty()){
				Object[] tempuserinfo = (Object[])userList.get(0);
				CodTaxempcodeVO tempuser = (CodTaxempcodeVO)tempuserinfo[0];
				user = new UserInfo();
				BeanUtils.copyProperties(user, tempuser);
				CodTaxorgcodeVO orgvo = new CodTaxorgcodeVO();
				BeanUtils.copyProperties(orgvo, (CodTaxorgcodeVO)tempuserinfo[1]);
				user.setCodTaxorgcodeVO(orgvo);
				user.setOrgName(orgvo.getTaxorgname());
				
//				//获取数据权限
//				List rightlist = DataRightsBI.loadDataRightsFromDB(hibernateTemplate.getCurrentSession(),orgvo,tempuser.getTaxempcode());
//				user.setUserrights(rightlist);
//				user.printallrights();
				returnBean.setUserInfo(user);
				returnBean.setRoles(this.getAuthorityRoles(user));
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("【检验当前用户是否存在异常】", e);
		}
		return returnBean;
	}

	/**
	 * 当前用户主体信息存在的话，获取用户对应的角色信息
	 * @param user
	 * @return
	 */
	protected List<RoleBO>getAuthorityRoles(UserInfo user){
		String allString = "select new com.tfhz.framework.authority.services.Authority.bo.RoleBO(role.role_id,role.role_code) ";
		StringBuilder hql1 = new StringBuilder();
		StringBuilder hql2 = new StringBuilder();
		hql1.append(allString);
		hql1.append(" from SystemRolesVO role, SystemUser2roleVO u2r where ");
		hql1.append("role.enabled='1' and role.role_id=u2r.role_id and u2r.user_id=:userId");
		hql2.append(allString);
		hql2.append(" from SystemRolesVO role, SystemGroup2roleVO g2r ,SystemUser2groupVO u2g where ");
		hql2.append("role.enabled='1' and role.role_id=g2r.role_id and g2r.group_id=u2g.group_id and u2g.user_id =:user_id ");
		List tempRoles = new ArrayList();
		try {
			//通过用户id来获取用户角色
			List userRoles = hibernateTemplate.findByNamedParam(hql1.toString(), "userId", user.getTaxempcode());
			tempRoles.addAll(userRoles);
			//通过用户组关联来获取用户角色
			List groupRoles = hibernateTemplate.findByNamedParam(hql2.toString(), "user_id", user.getTaxempcode());
			tempRoles.addAll(groupRoles);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("【获取用户对应的角色信息出现异常】", e);
		}
		
		return tempRoles;
	}
	/**
	 * 加载权限资源
	 */
	@RequestMapping(value = "/getUrlMetadataSource")
	@ResponseBody
	public AuthorityBean getUrlMetadataSource(@RequestBody AuthorityBean req) {
		AuthorityBean returnBean = new AuthorityBean();
		StringBuilder hql = new StringBuilder();
		hql.append("select new com.tfhz.framework.authority.services.Authority.bo.Url2RoleBO(res.resource_content,role.role_code) from ");
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
		return returnBean;
	}

	/**
	 * 通过用户ID或者组ID来验证当前用户是否可以访问当前资源
	 */
	@RequestMapping(value = "/checkDirectAccess")
	@ResponseBody
	public AuthorityBean checkUserAccess(@RequestBody AuthorityBean req) {
		AuthorityBean returnBean = new AuthorityBean();
		UrlCheckBO urlCheck = new UrlCheckBO();
		StringBuilder hql = new StringBuilder();
		hql.append("from SystemResourcesVO res,");
		if (req.getUrlCheck().isAccessUserId()) {
			hql.append("SystemUser2resourceVO u2r where ");
			hql.append("u2r.user_id=:user_id and u2r.resource_id=res.resource_id and ");
		}else{
			hql.append("SystemGroup2resourceVO g2r,SystemUser2groupVO u2g where ");
			hql.append("g2r.resource_id=res.resource_id and ");
			hql.append("g2r.group_id=u2g.group_id and u2g.user_id=:user_id and ");
		}
		
		hql.append("res.resource_content like '%"+req.getUrlCheck().getUrl()+"'");
		List user2Res = null;
		try {
			user2Res = hibernateTemplate.findByNamedParam(hql.toString(),"user_id",req.getUrlCheck().getId());
			
			if(!user2Res.isEmpty()){
				urlCheck.setAccess(true);
			}else{
				urlCheck.setAccess(false);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("【获取用户对应的角色信息出现异常】", e);
		}
		returnBean.setUrlCheck(urlCheck);
		return returnBean;
	}


	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}
}
