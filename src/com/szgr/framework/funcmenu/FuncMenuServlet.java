package com.szgr.framework.funcmenu;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.beanutils.PropertyUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.authority.services.Authority.bo.GrantedAuthorityBO;
import com.szgr.framework.authority.vo.SystemAllcodemainVO;
import com.szgr.framework.cache.options.code.ICodeOption;

/**
 * ReplicationServer
 */

@Controller
@RequestMapping("/FuncMenuServlet")
public class FuncMenuServlet {
	public static Map<String , Integer> typemap= new HashMap();
	static{
		typemap.put("y", GregorianCalendar.YEAR);
		typemap.put("m", GregorianCalendar.MONTH);
		typemap.put("d",GregorianCalendar.DAY_OF_MONTH);
	}
	private static final org.slf4j.Logger log = org.slf4j.LoggerFactory
			.getLogger(FuncMenuServlet.class);
	@Autowired
	HibernateTemplate hibernateTemplate;
	// 代码缓存
	@Resource(name = "com.szgr.cache.options.code.CodeOption")
	private ICodeOption codeOption;

	@RequestMapping(value = "/getFuncMenu")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public FuncMenuBean getFuncMenu() {

		String hql = " from SystemAllcodemainVO where enabled = '1' ";
		Session session = hibernateTemplate.getSessionFactory()
				.getCurrentSession();
		Query query = session.createQuery(hql);
		List<SystemAllcodemainVO> list = query.list();
		for (SystemAllcodemainVO vo : list) {
			String codetablename = vo.getCodetablename();
			String codevoName = vo.getCodevoname();
			String codekey = vo.getCodekey();
			String codevalue = vo.getCodevalue();
			Class clazz = null;
			try {
				clazz = Class.forName(codevoName);
			} catch (ClassNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			// System.out.println("------" + voName);
			// System.out.println("------" + keyfield);
			// System.out.println("------" + valuefield);
			try {
				codeOption.genCodeVOCache(codetablename, codekey, codevalue,
						" and 1=1 ", clazz);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		FuncMenuBean returnBean = new FuncMenuBean();
		// Set<GrantedAuthority> authorities = null;
		// String roleIdStr = "";
		// Object principal = SecurityContextHolder.getContext()
		// .getAuthentication().getPrincipal();
		//
		// if (principal instanceof UserInfo) {
		// authorities = ((UserInfo) principal).getAuthorities();
		// }
		// if (authorities != null) {
		// roleIdStr = this.createRoleIdStr(authorities);
		// } else {
		//
		// }
		log.info("funcmetnu , userinfo = "
				+ SystemUserAccessor.getInstance().getTaxempcode());
		Set<GrantedAuthority> authorities = SystemUserAccessor.getInstance()
				.getAuthorities();
		String roleIdStr = "";
		if (authorities != null) {
			roleIdStr = this.createRoleIdStr(authorities);
		} else {

		}

		StringBuffer menuJsBuffer = new StringBuffer();

		StringBuilder sql = new StringBuilder();
		sql.append(" select distinct new com.szgr.framework.funcmenu.FuncMenuBo( res.resource_id,res.resource_name,res.resource_content,res.parent_menu_id,res.leaf_type,res.sort_str,res.selfId,res.parentId,res.isDouble,res.bgColor,res.tileType,res.imgSrc,res.brandName,res.brandCount,res.badgeColor,res.tileHtml,res.menuIcon,res.menuUrl,res.todoUrl,res.todoMenuid) ");
		sql.append(" from SystemRole2resourceVO r2r,SystemResourcesVO res where ");
		sql.append(" r2r.role_id in (" + roleIdStr + ") and ");
		sql.append("r2r.resource_id=res.resource_id and res.leaf_type <> '1' and res.enabled='1' ");
		sql.append("order by res.sort_str asc");
		log.info("rolefunsql = " + sql);
		List funcMenuList = new ArrayList();
		try {
			funcMenuList = hibernateTemplate.find(sql.toString());
			List funcMenuMainList = new ArrayList();
			List funcMenuSubList = new ArrayList();
			if (funcMenuList != null && funcMenuList.size() > 0) {
				for (int i = 0; i < funcMenuList.size(); i++) {
					FuncMenuBo funcMenuBo = (FuncMenuBo) funcMenuList.get(i);
					if (funcMenuBo.getLeaf_type().equals("2")) {
						funcMenuMainList.add(funcMenuBo);
					}
					if (funcMenuBo.getLeaf_type().equals("3")) {
						funcMenuSubList.add(funcMenuBo);
					}
					// funcMenuList.add(funcMenuBo);
				}
				// System.out.println("------------------"
				// + funcMenuMainList.size());
				// System.out.println("------------------"
				// + funcMenuSubList.size());
				menuJsBuffer.append("[");
				for (int i = 0; i < funcMenuMainList.size(); i++) {
					FuncMenuBo mainBo = (FuncMenuBo) funcMenuMainList.get(i);
					menuJsBuffer.append("{");
					menuJsBuffer.append("\"selfId\":\"" + mainBo.getSelfId()
							+ "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"parentId\":\""
							+ mainBo.getParentId() + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"isDouble\":\""
							+ mainBo.getIsDouble() + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"bgColor\":\"" + mainBo.getBgColor()
							+ "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"tileType\":\""
							+ mainBo.getTileType() + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"imgSrc\":\"" + mainBo.getImgSrc()
							+ "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"brandName\":\""
							+ mainBo.getBrandName() + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"brandCount\":\""
							+ mainBo.getBrandCount() + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"badgeColor\":\""
							+ mainBo.getBadgeColor() + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"tileHtml\":\"" + "" + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"todoUrl\":\"" + changeTodoUrl(mainBo.getTodoUrl())  + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"todoMenuid\":\"" + mainBo.getTodoMenuid()  + "\"");
					// menuJsBuffer.append("\"tileHtml\":\""
					// + mainBo.getTileHtml() + "\"");
					menuJsBuffer.append(",");
					menuJsBuffer.append("\"submenus\":[");
					for (int j = 0; j < funcMenuSubList.size(); j++) {
						FuncMenuBo subBo = (FuncMenuBo) funcMenuSubList.get(j);
						if (mainBo.getSelfId()
								.equals(subBo.getParent_menu_id())) {
							menuJsBuffer.append("{\"selfId\":\""
									+ subBo.getSelfId() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"parentId\":\""
									+ subBo.getParentId() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"resource_id\":\""
									+ subBo.getResource_id() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"isDouble\":\""
									+ subBo.getIsDouble() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"bgColor\":\""
									+ subBo.getBgColor() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"tileType\":\""
									+ subBo.getTileType() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"imgSrc\":\""
									+ subBo.getImgSrc() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"brandName\":\""
									+ subBo.getBrandName() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"brandCount\":\""
									+ subBo.getBrandCount() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"badgeColor\":\""
									+ subBo.getBadgeColor() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"tileHtml\":\"" + "" + "\"");
							// menuJsBuffer.append("\"tileHtml\":\""
							// + subBo.getTileHtml() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"menuIcon\":\""
									+ subBo.getMenuIcon() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"menuUrl\":\""
									+ subBo.getMenuUrl() + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"todoUrl\":\""
									+ changeTodoUrl(subBo.getTodoUrl()) + "\"");
							menuJsBuffer.append(",");
							menuJsBuffer.append("\"todoMenuid\":\"" + subBo.getTodoMenuid()  + "\"");
							menuJsBuffer.append("},");
						}
					}
					if (menuJsBuffer.substring(
							menuJsBuffer.toString().length() - 1,
							menuJsBuffer.toString().length()).equals("[")) {
						menuJsBuffer.append("]},");
					} else {
						menuJsBuffer.delete(
								menuJsBuffer.toString().length() - 1,
								menuJsBuffer.toString().length());
						menuJsBuffer.append("]}");
						menuJsBuffer.append(",");

					}

				}
				menuJsBuffer.delete(menuJsBuffer.toString().length() - 1,
						menuJsBuffer.toString().length());
				menuJsBuffer.append("]");
				// System.out.println("funcMenu:" + menuJsBuffer.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			return returnBean;
		}

		FuncMenuBean funcMenuBean = new FuncMenuBean();
		funcMenuBean.setFuncMenuJson(menuJsBuffer.toString());
		return funcMenuBean;
	}
	
	@RequestMapping(value = "/getTodoMenu")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public List<FuncMenuBo> getTodoMenu() {
		StringBuilder sql = new StringBuilder();
		sql.append(" select distinct new com.szgr.framework.funcmenu.FuncMenuBo( res.resource_id,res.resource_name,res.resource_content,res.parent_menu_id,res.leaf_type,res.sort_str,res.selfId,res.parentId,res.isDouble,res.bgColor,res.tileType,res.imgSrc,res.brandName,res.brandCount,res.badgeColor,res.tileHtml,res.menuIcon,res.menuUrl,res.todoUrl,res.todoMenuid) ");
		sql.append(" from SystemResourcesVO res where res.resource_id in (select todoMenuid from SystemResourcesVO) ");
		log.info("rolefunsql = " + sql);
		List<FuncMenuBo> funcMenuList =  hibernateTemplate.find(sql.toString());
		return funcMenuList;
	}
	
	
	@RequestMapping(value = "/todo/{type}/{taxempcode}/{taxorgcode}")
	@ResponseBody
	@Transactional(propagation = Propagation.NOT_SUPPORTED, readOnly = true)
	public Map getTodoNum(@PathVariable(value = "type") String type ,@PathVariable(value = "taxempcode") String taxempcode , @PathVariable(value = "taxorgcode") String taxorgcode) {
		System.out.println("==type=="+type);
		System.out.println("==taxempcode=="+taxempcode);
		System.out.println("==taxorgcode=="+taxorgcode);
		Map ret = new HashMap();
		Map params = new HashMap();
		params.put("type", type);
		params.put("taxempcode", taxempcode);
		params.put("taxorgcode", taxorgcode);
		ret.put("num", 1);
		ret.put("params", params);
		return ret;
	}

	/**
	 * 生成roleIdstr（例如'a','b','c'）
	 * 
	 * @param authorities
	 * @return
	 */
	public String createRoleIdStr(Set<GrantedAuthority> authorities) {
		String tempStr = "";
		for (Object tempObj : authorities) {
			tempStr += "'"
					+ ((GrantedAuthorityBO) tempObj).getRoleBO().getRole_id()
					+ "',";
		}
		tempStr = tempStr.substring(
				0,
				tempStr.indexOf(",") != -1 ? tempStr.length() - 1 : tempStr
						.length());
		// System.out.println(tempStr);
		return tempStr;
	}

	private String changeTodoUrl(String todoUrl) {
		if(todoUrl==null){
			return "";
		}else{
			return getMsgFromTemplate(todoUrl,SystemUserAccessor.getInstance());
		}
	}

	private String getMsgFromTemplate(String template,Object obj){
		String ret = template;
		String pattern = "\\$\\s*\\(\\s*([\\w$+-]+)\\s*\\)";
		Pattern r = Pattern.compile(pattern);
		Matcher m = r.matcher(template);
		while (m.find( )) {
			try{
				String str = m.group(0);
				String testStr = m.group(1);
				String pattern1 = "(\\w+)\\s*([+-])\\s*(\\d+)([ymd])";
				Pattern p1 = Pattern.compile(pattern1);
				if(testStr.startsWith("$")){
					String testStr1 = testStr.substring(1);
					Matcher m1 = p1.matcher(testStr1);
					if(m1.find()){
						if("today".equals(m1.group(1))){
							GregorianCalendar today = new GregorianCalendar();
							int num = Integer.parseInt(m1.group(3));
							if("-".equals(m1.group(2))){
								num = -num;
							}
							today.add(typemap.get(m1.group(4)), num);
							str =  new SimpleDateFormat("yyyyMMdd").format(today.getTime());
						}
					}
				}else{
					Matcher m1 = p1.matcher(testStr);
					if(m1.find()){
						Object retobj = PropertyUtils.getProperty(obj,m1.group(1));
						if(retobj instanceof java.util.Date){
							GregorianCalendar dateobj = new GregorianCalendar();
							dateobj.setTime((Date)retobj);
							int num = Integer.parseInt(m1.group(3));
							if("-".equals(m1.group(2))){
								num = -num;
							}
							dateobj.add(typemap.get(m1.group(4)), num);
							str =  new SimpleDateFormat("yyyyMMdd").format(dateobj.getTime());
						}else{
							str =String.valueOf(retobj);
						}
					}else{
						Object retobj = PropertyUtils.getProperty(obj,testStr);
						if(retobj instanceof java.util.Date){
							str =  new SimpleDateFormat("yyyyMMdd").format((Date)retobj);
						}else{
							str =String.valueOf(retobj);
						}
					}
				}
				ret = ret.replace(m.group(0), str);
			}catch(NoSuchMethodException ex){
				ex.printStackTrace();
				if(m.group(1).toLowerCase().indexOf("date")>=0){
					String str =  new SimpleDateFormat("yyyyMMdd").format(new Date());
					ret = ret.replace(m.group(0), str);
				}
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
		return ret;
	}
}
