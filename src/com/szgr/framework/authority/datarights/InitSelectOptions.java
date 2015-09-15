package com.szgr.framework.authority.datarights;

import java.util.Collection;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

import com.szgr.framework.authority.impl.CodTaxempcodeOptImpl;
import com.szgr.framework.authority.impl.CodTaxorgcodeOptImpl;
import com.szgr.framework.authority.impl.PubConstants;
import com.szgr.framework.util.SpringContextUtil;


@Component("om.tfhz.ynds.nsfw.business.common.InitSelectOptions")
public class InitSelectOptions {
	private static Logger log = Logger.getLogger(InitSelectOptions.class);

	public InitSelectOptions() {
	}

	/**
	 * 根据地税机关部门代码获得下级下拉选项列表（由上次的选择获得下次的初始值）
	 * @param taxOrgSup String
	 * 上次选择的州市级机关代码
	 * @param taxOrg String
	 * 上次选择的县区级机关代码
	 * @param taxDept String
	 * 上次选择的地税部门代码
	 * @param empType String
	 * 想要获得的税务人员类型
	 * @return HashMap
	 */
	public static HashMap InitTaxOrgSelectOptionsWithDataRights(
			String taxOrgSup, String taxOrg, String taxDept, String empType) {
		log.debug("Enter InitSelectOptions InitTaxOrgSelectOptionsWithDataRights.");
        log.info("InitTaxOrgSelectOptionsWithDataRights:taxOrgSup"+taxOrgSup+",taxorgcode="+taxOrg+",taxdeptcode="+taxDept+",emptype="+empType);
		HashMap result = new HashMap();

		CodTaxorgcodeOptImpl taxOrgCodeOptImpl = (CodTaxorgcodeOptImpl) SpringContextUtil
				.getApplicationContext().getBean("codTaxorgcodeOptImpl");
        
		Collection taxOrgOption = taxOrgCodeOptImpl.getTaxsuperOrgCodeOptions(
				PubConstants.TAXORGNAME_SHORT, PubConstants.TAXORGANIZATION);
		result.put("taxSupOrgOption", taxOrgOption);
		// xuhong edit  begin
		System.out.println("taxSupOrgOption = "+taxOrgOption.size());
        if(taxOrgOption.size() > 1){
        	result.put("taxOrgOption", new java.util.ArrayList());
        	result.put("taxDeptOption", new java.util.ArrayList());
        	result.put("taxEmpOption", new java.util.ArrayList());
        	return result;
        }
        // xuhong edit end
		if (!"".equals(taxOrgSup) && null != taxOrgSup) {
			taxOrgOption = taxOrgCodeOptImpl
					.getOrgOptionBySupCodeWithDataRights(taxOrgSup);
		} else {
			taxOrgOption = taxOrgCodeOptImpl
					.getTaxOrgCodeOptions(PubConstants.TAXORGNAME_SHORT,
							PubConstants.TAXORGANIZATION);
		}
		result.put("taxOrgOption", taxOrgOption);

		if (!"".equals(taxOrg) && null != taxOrg) {
			taxOrgOption = taxOrgCodeOptImpl
					.getDeptOptionByOrgCodeWithDataRights(taxOrg);
		} else if (!"".equals(taxOrgSup) && null != taxOrgSup) {
			taxOrgOption = taxOrgCodeOptImpl.getDeptOptionBySupCode(taxOrgSup);
		} else {
			taxOrgOption = taxOrgCodeOptImpl
					.getTaxDeptCodeOptions(PubConstants.TAXORGNAME_SHORT,
							PubConstants.TAXORGANIZATION);
		}
		result.put("taxDeptOption", taxOrgOption);

		CodTaxempcodeOptImpl taxEmpCodeOptImpl = new CodTaxempcodeOptImpl();
		Collection taxEmpOption = null;
		if (!"".equals(taxDept) && null != taxDept) {
			taxEmpOption = taxEmpCodeOptImpl.getEmpOptionByOrgCode(taxDept,
					empType);
		} else if (!"".equals(taxOrg) && null != taxOrg) {
			taxEmpOption = taxEmpCodeOptImpl.getEmpOptionUnderOrgCode(taxOrg,
					empType);
		} else if (!"".equals(taxOrgSup) && null != taxOrgSup) {
			taxEmpOption = taxEmpCodeOptImpl.getEmpOptionUnderOrgCode(
					taxOrgSup, empType);
		} else {
			taxEmpOption = taxEmpCodeOptImpl
					.getTaxEmpCodeWithDataRigths(empType);
		}
		result.put("taxEmpOption", taxEmpOption);
		log.debug("Exit InitSelectOptions InitTaxOrgSelectOptionsWithDataRights.");
		return result;
	}

	/**
	 * 根据地税机关部门代码获得下级下拉选项列表
	 * @param empType String
	 * 想要获得的税务人员类型
	 * @return HashMap
	 */
	public static HashMap InitTaxOrgSelectOptions(String empType) {
		log.debug("Enter InitSelectOptions InitTaxOrgSelectOptions.");

		HashMap result = new HashMap();

		CodTaxorgcodeOptImpl taxOrgCodeOptImpl = (CodTaxorgcodeOptImpl) SpringContextUtil
				.getApplicationContext().getBean("codTaxorgcodeOptImpl");

		Collection taxOrgOption = taxOrgCodeOptImpl.getTaxsuperOrgCodeOptions(
				PubConstants.TAXORGNAME_SHORT, PubConstants.TAXORGANIZATION);
		result.put("taxSupOrgOption", taxOrgOption);

		taxOrgOption = taxOrgCodeOptImpl.getTaxOrgCodeOptions(
				PubConstants.TAXORGNAME_SHORT, PubConstants.TAXORGANIZATION);
		result.put("taxOrgOption", taxOrgOption);

		taxOrgOption = taxOrgCodeOptImpl.getTaxDeptCodeOptions(
				PubConstants.TAXORGNAME_SHORT, PubConstants.TAXORGANIZATION);
		result.put("taxDeptOption", taxOrgOption);

		CodTaxempcodeOptImpl taxEmpCodeOptImpl = new CodTaxempcodeOptImpl();
		Collection taxEmpOption = null;
		taxEmpOption = taxEmpCodeOptImpl.getTaxEmpCodeWithDataRigths(empType);
		result.put("taxEmpOption", taxEmpOption);

		log.debug("Exit InitSelectOptions InitTaxOrgSelectOptions.");
		return result;
	}

	/**
	 * 根据地税机关部门代码获得下级下拉选项列表
	 * @param taxOrgSup String
	 * 上次选择的州市级机关代码
	 * @param taxOrg String
	 * 上次选择的县区级机关代码
	 * @param taxDept String
	 * 上次选择的地税部门代码
	 * @return HashMap
	 * 老方法，不建议使用
	 */
	public static HashMap InitTaxOrgSelectOptions(String taxOrgSup,
			String taxOrg, String taxDept) {
		log.debug("Enter InitSelectOptions InitTaxOrgSelectOptions.");

		HashMap result = new HashMap();

		CodTaxorgcodeOptImpl taxOrgCodeOptImpl = (CodTaxorgcodeOptImpl) SpringContextUtil
				.getApplicationContext().getBean("codTaxorgcodeOptImpl");

		Collection taxOrgOption = taxOrgCodeOptImpl.getTaxsuperOrgCodeOptions(
				PubConstants.TAXORGNAME_SHORT, PubConstants.TAXORGANIZATION);
		result.put("taxSupOrgOption", taxOrgOption);

		if (!"".equals(taxOrgSup) && null != taxOrgSup) {
			taxOrgOption = taxOrgCodeOptImpl
					.getOrgOptionBySupCodeWithDataRights(taxOrgSup);
		} else {
			taxOrgOption = taxOrgCodeOptImpl
					.getTaxOrgCodeOptions(PubConstants.TAXORGNAME_SHORT,
							PubConstants.TAXORGANIZATION);
		}
		result.put("taxOrgOption", taxOrgOption);

		if (!"".equals(taxOrg) && null != taxOrg) {
			taxOrgOption = taxOrgCodeOptImpl
					.getDeptOptionByOrgCodeWithDataRights(taxOrg);
		} else {
			taxOrgOption = taxOrgCodeOptImpl
					.getTaxDeptCodeOptions(PubConstants.TAXORGNAME_SHORT,
							PubConstants.TAXORGANIZATION);
		}
		result.put("taxDeptOption", taxOrgOption);

		CodTaxempcodeOptImpl taxEmpCodeOptImpl = new CodTaxempcodeOptImpl();
		Collection taxEmpOption = null;
		if (!"".equals(taxDept) && null != taxDept) {
			taxEmpOption = taxEmpCodeOptImpl.getEmpOptionByOrgCode(taxDept,
					PubConstants.TAXEMPCODE_TAXMANAGER_TYPE);
		} else {
			taxEmpOption = taxEmpCodeOptImpl
					.getTaxEmpCodeWithDataRigths(PubConstants.TAXEMPCODE_TAXMANAGER_TYPE);
		}
		result.put("taxEmpOption", taxEmpOption);
		log.debug("Exit InitSelectOptions InitTaxOrgSelectOptions.");
		return result;
	}

//	/**
//	 * 获取发票类型代码表
//	 *add by 周德金 2011-5-11
//	 * @return
//	 */
//	public static Map initInvclasstypeOption() {
//		Map retMap = new HashMap();
//		CodInvtypecodeOptImpl invtypecodeOptImpl = (CodInvtypecodeOptImpl) SpringContextUtil
//				.getApplicationContext().getBean("codInvtypecodeOptImpl");
//		retMap.put("invClasstypeOption", invtypecodeOptImpl.getInvtypecode());
//		return retMap;
//	}
//
//	
//	/**
//	 * 根据发票类型获取发票种类代码表
//	 *add by 周德金 2011-5-11
//	 * @return
//	 */
//	public static Map initInvoicecodeOption(String invtypecode) {
//		Map retMap = new HashMap();
//		CodInvtypecodeOptImpl invtypecodeOptImpl = (CodInvtypecodeOptImpl) SpringContextUtil
//				.getApplicationContext().getBean("codInvtypecodeOptImpl");
//		if (invtypecode != null && !"".equals(invtypecode)) { 
//			retMap.put("invoiceOption", invtypecodeOptImpl
//					.getInvoicecodeByInvtypecode(invtypecode));
//		} else {
//			retMap.put("invoiceOption", invtypecodeOptImpl.getOptions()
//					);
//		}
//
//		return retMap;
//	}
	
	
	
}
