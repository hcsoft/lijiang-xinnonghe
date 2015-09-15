package com.szgr.framework.authority.options;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.szgr.framework.authority.UserInfo;
import com.szgr.framework.authority.datarights.InitSelectOptions;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.authority.impl.CodTaxempcodeOptImpl;
import com.szgr.framework.authority.impl.CodTaxorgcodeOptImpl;
import com.szgr.framework.cache.service.CacheService;



/**
 * 
 */
@Controller
@RequestMapping("/soption")
@Component
@Scope("prototype")
public class CommonOptionServer {
	private static Logger log = Logger.getLogger(CommonOptionServer.class);
	
	/**
	 *税务机关获取组件 
	 */
	@Resource(name="codTaxorgcodeOptImpl")
	CodTaxorgcodeOptImpl codTaxorgcodeOptImpl;
	

	/**
	 *税务机关获取组件 
	 */
	@Resource(name="codTaxempcodeOptImpl")
	CodTaxempcodeOptImpl codTaxempcodeOptImpl;
	
	
	
	private UserInfo getCurrentUserInfo(){
		UserInfo result = null;
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest(); 
        HttpSession httpSession = request.getSession();
		if (httpSession.getAttribute("userInfoSession") != null) {
			result = (UserInfo) httpSession.getAttribute("userInfoSession");
		}
		return result;
	}
	/**
	 * 页面初始化
	 * 
	 */
	@RequestMapping(value = "/taxOrgOptionInit")
	@ResponseBody
	public CommonOptionBean init(@RequestParam("moduleAuth")
			String moduleAuth, @RequestParam("emptype") String emptype){
		
//		System.out.println("moduleAuth--------------" + moduleAuth);
//		System.out.println("emptype-----------------" + emptype);
		//----------------初始化模块ID-------------------------
		
		if(moduleAuth!=null){			
			SystemUserAccessor.getInstance().insertModuleAuth(moduleAuth);
		}
		log.info("auth=="+SystemUserAccessor.getInstance().getAuthDescription());
		//----------------------------------------------------
		CommonOptionBean returnBean = new CommonOptionBean();
		returnBean.setCurrentUserInfo(getCurrentUserInfo());
		StringBuilder hql = new StringBuilder();
		List menuList = null;
		try {
			//调用方法获得下拉列表的初始值
			log.info("开始获取权限.............");
	        HashMap map = InitSelectOptions.InitTaxOrgSelectOptionsWithDataRights(null,  //州市级机关代码
	        		null, null,  //县区级机关代码, 主管地税部门代码
	        		emptype);
	        		//PubConstants.TAXEMPCODE_LEVY_TYPE); //税务人员类型
	        //将初始值set到request的Attribute中
	        returnBean.setTaxSupOrgOption((List)map.get("taxSupOrgOption"));
	        returnBean.setTaxOrgOption((List)map.get("taxOrgOption"));
	        returnBean.setTaxDeptOption((List)map.get("taxDeptOption"));
	        returnBean.setTaxEmpOption((List)map.get("taxEmpOption"));
	        JSONArray taxSupOrgOptionJsonArray = CacheService.convertOptionObject2CommonOption((List) map.get("taxSupOrgOption"));
	        JSONArray taxOrgOptionJsonArray = CacheService.convertOptionObject2CommonOption((List) map.get("taxOrgOption"));
	        JSONArray taxDeptOptionJsonArray = CacheService.convertOptionObject2CommonOption((List) map.get("taxDeptOption"));
	        JSONArray taxEmpOptionJsonArray = CacheService.convertOptionObject2CommonOption((List) map.get("taxEmpOption"));
	        returnBean.setTaxSupOrgOptionJsonArray(taxSupOrgOptionJsonArray);
	        returnBean.setTaxOrgOptionJsonArray(taxOrgOptionJsonArray);
	        returnBean.setTaxDeptOptionJsonArray(taxDeptOptionJsonArray);
	        returnBean.setTaxEmpOptionJsonArray(taxEmpOptionJsonArray);
	        System.out.println("taxSupOrgOptionJsonArray==========" + taxSupOrgOptionJsonArray.size());
			System.out.println("taxOrgOptionJsonArray==========" + taxOrgOptionJsonArray.size());
			System.out.println("taxDeptOptionJsonArray==========" + taxDeptOptionJsonArray.size());
			System.out.println("taxEmpOptionJsonArray==========" + taxEmpOptionJsonArray.size());
//	        
//	        System.out.println("==========" + ((List) map.get("taxSupOrgOption")).size());
//			System.out.println("==========" + ((List) map.get("taxOrgOption")).size());
//			System.out.println("==========" + ((List) map.get("taxDeptOption")).size());
//			System.out.println("==========" + ((List) map.get("taxEmpOption")).size());
	        String userAuthorizion = SystemUserAccessor.getInstance().getUserTaxOrgVO().getOrgclass();
	        returnBean.setUserAuthorizion(userAuthorizion);
		} catch (Exception e) {
			log.error("【初始化信息出现异常】", e);
			return returnBean;
		}
		return returnBean;
	}
	/**
	 * 
	 * 根据州市级地税机关获得县区级地税机关选项列表
	 */
	@RequestMapping(value = "/taxOrgOptionBySup")
	@ResponseBody
	public CommonOptionBean getOrgOptionBySupCode(@RequestParam("taxSuperOrgCode") String taxSuperOrgCode){
		CommonOptionBean returnBean = new CommonOptionBean();
				try{
					List orgList =  (List)this.codTaxorgcodeOptImpl.getOrgOptionBySupCode(taxSuperOrgCode);
					System.out.println("orgList.size===================="+orgList.size());
					JSONArray taxOrgOptionJsonArray = CacheService.convertOptionObject2CommonOption(orgList);
					JSONArray taxDeptOptionJsonArray = new JSONArray();
					JSONArray taxEmpOptionJsonArray = new JSONArray();
					returnBean.setTaxOrgOptionJsonArray(taxOrgOptionJsonArray);
					returnBean.setTaxDeptOptionJsonArray(taxDeptOptionJsonArray);
					returnBean.setTaxEmpOptionJsonArray(taxEmpOptionJsonArray);
//					returnBean.setReturnList(orgList);
				}catch (Exception e) {
					log.error("【获取县区级地税机关信息出现异常！】", e);
					return returnBean;
				}
				
				return returnBean;
		 
	}
	/**
	 * 
	 * 根据县区级地税机关获得主管地税部门选项列表
	 */
	@RequestMapping(value = "/taxDeptOptionByOrg")
	@ResponseBody
	public CommonOptionBean getDeptOptionByOrgCode(@RequestParam("taxOrgCode") String taxOrgCode){
		CommonOptionBean returnBean = new CommonOptionBean();
				try{
					List orgList =  (List)this.codTaxorgcodeOptImpl.getDeptOptionByOrgCode(taxOrgCode);
					JSONArray taxDeptOptionJsonArray = CacheService.convertOptionObject2CommonOption(orgList);
					JSONArray taxEmpOptionJsonArray = new JSONArray();
					returnBean.setTaxDeptOptionJsonArray(taxDeptOptionJsonArray);
					returnBean.setTaxEmpOptionJsonArray(taxEmpOptionJsonArray);
					returnBean.setReturnList(orgList);
				}catch (Exception e) {
					log.error("【获取主管地税部门信息出现异常！】", e);
					return returnBean;
				}
				
				return returnBean;
		 
	}
	
	/**
	 * 
	 * 根据县区级地税机关获得主管地税部门选项列表
	 */
	@RequestMapping(value = "/getTaxEmpByOrgCode")
	@ResponseBody
	public CommonOptionBean getTaxEmpByOrgCode(@RequestParam("taxDeptCode") String taxDeptCode,@RequestParam("emptype") String emptype){
//		System.out.println("taxDeptCode------------------" + taxDeptCode);
//		System.out.println("emptype------------------" + emptype);
		CommonOptionBean returnBean = new CommonOptionBean();
				try{
					List orgList =  (List)this.codTaxempcodeOptImpl.getEmpOptionByOrgCode(taxDeptCode, emptype);
					JSONArray taxEmpOptionJsonArray = CacheService.convertOptionObject2CommonOption(orgList);
					returnBean.setTaxEmpOptionJsonArray(taxEmpOptionJsonArray);
					returnBean.setReturnList(orgList);
				}catch (Exception e) {
					log.error("【获取人员信息出现异常！】", e);
					return returnBean;
				}
				
				return returnBean;
		 
	}
	

}