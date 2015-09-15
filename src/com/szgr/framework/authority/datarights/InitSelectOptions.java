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
	 * ���ݵ�˰���ز��Ŵ������¼�����ѡ���б����ϴε�ѡ�����´εĳ�ʼֵ��
	 * @param taxOrgSup String
	 * �ϴ�ѡ������м����ش���
	 * @param taxOrg String
	 * �ϴ�ѡ������������ش���
	 * @param taxDept String
	 * �ϴ�ѡ��ĵ�˰���Ŵ���
	 * @param empType String
	 * ��Ҫ��õ�˰����Ա����
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
	 * ���ݵ�˰���ز��Ŵ������¼�����ѡ���б�
	 * @param empType String
	 * ��Ҫ��õ�˰����Ա����
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
	 * ���ݵ�˰���ز��Ŵ������¼�����ѡ���б�
	 * @param taxOrgSup String
	 * �ϴ�ѡ������м����ش���
	 * @param taxOrg String
	 * �ϴ�ѡ������������ش���
	 * @param taxDept String
	 * �ϴ�ѡ��ĵ�˰���Ŵ���
	 * @return HashMap
	 * �Ϸ�����������ʹ��
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
//	 * ��ȡ��Ʊ���ʹ����
//	 *add by �ܵ½� 2011-5-11
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
//	 * ���ݷ�Ʊ���ͻ�ȡ��Ʊ��������
//	 *add by �ܵ½� 2011-5-11
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
