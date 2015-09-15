package com.szgr.framework.authority.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.szgr.framework.authority.datarights.ListUtil;
import com.szgr.framework.authority.datarights.OptionObject;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.cache.service.CacheService;
import com.szgr.framework.util.TypeChecker;
import com.thtf.ynds.vo.CodTaxempcodeVO;

/**
 * Created by ant task OptionGen.
 * 
 */
@Component("codTaxempcodeOptImpl")
@Scope("prototype")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class CodTaxempcodeOptImpl {
	private static Logger log = Logger.getLogger(CodTaxempcodeOptImpl.class);
	@Autowired
	HibernateTemplate hibernateTemplate;

	private static Map cachedMap = new HashMap();

	/**
	 * ��������д������ݵ�List
	 */
	private static List cachedList = new ArrayList();

	/**
	 * ������е�˰����Ա����
	 * 
	 * @return Collection
	 */
	public Collection getOptions() {
		return this.cachedList;
	}

	public CodTaxempcodeOptImpl() {
		this.initOptions();
	}

	/**
	 * �����ݿ��г�ʼװ�ش����
	 * 
	 * @return Collection
	 */
	public void initOptions() {
		List list = new ArrayList();
		list.add(new OptionObject("", " ", new CodTaxempcodeVO()));
		List tmpList = CacheService.getCachelist("COD_TAXEMPCODE");
		this.cachedList = tmpList;
	}

	/**
	 * �ӻ�����ȡ����˰����Ա
	 * 
	 * @return Collection
	 */
	public Collection getTaxEmpCodeOptions() {
		Collection list = cachedList;
		return list;
	}

	/**
	 * getEmpOptionsByOrgCode ���ݵ�˰���ػ��Ż��˰�����Աѡ���б� ������ʹ��
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection
	 */
	public Collection getEmpOptionByOrgCode(String orgCode) {
		return getEmpOptionByOrgCode(orgCode, null);
	}

	/**
	 * getEmpOptionsByOrgCode ���ݵ�˰���ػ��Ż�ú���Ա���ͻ�ȡ˰����Ա����(����ֱ��) ������ʹ�õķ���
	 * 
	 * @param orgCode
	 *            String �������ش���
	 * @param emptype
	 *            String ˰����Ա���ͣ���pubconstants�������� emptype Ϊ������ʱѡ����������˰����Ա
	 * @return Collection add by liu wanfu
	 */
	public Collection getEmpOptionByOrgCode(String orgCode, String emptype) {
		List list = new ArrayList();
		// Collection list = new ArrayList();
		// ��Ӧ��ȡ��ѡ����������˰����
		if ("".equals(orgCode)) {
			list.add(new OptionObject("", "����ѡ���˰���ز���", new CodTaxempcodeVO()));
			return list;
		}

		list.add(new OptionObject("", " ", new CodTaxempcodeVO()));
		// ���˰����Ա����Ϊ�գ��������е�˰����Ա
		if (TypeChecker.isEmpty(emptype)) {
			Iterator iter = cachedList.iterator();
			iter.next();
			while (iter.hasNext()) {
				OptionObject optionObj = (OptionObject) iter.next();
				CodTaxempcodeVO vo = (CodTaxempcodeVO) optionObj.getObject();
				if (orgCode.equals(vo.getTaxorgcode())) {
					list.add(optionObj);
				}
			}
		} else {// ˰����Ա���Ͳ�Ϊ�գ�����˰����Ա���ͽ��й���
			Iterator iter = getTaxEmpCodeByEmpType(emptype).iterator();
			// iter.next();
			while (iter.hasNext()) {
				OptionObject optionObj = (OptionObject) iter.next();
				CodTaxempcodeVO vo = (CodTaxempcodeVO) optionObj.getObject();
				if (orgCode.equals(vo.getTaxorgcode())) {
					list.add(optionObj);
				}
			}
		}

		// if (list.size() > 0) {
		// OptionObject optionObj = new OptionObject("", " ",
		// new CodTaxempcodeVO());
		// list.add(0, optionObj);
		// }
		// else {
		// OptionObject optionObj = new OptionObject("", " ",
		// new CodTaxempcodeVO());
		// list.add(0, optionObj);
		// }
		return (Collection) list;
	}

	/**
	 * getEmpOptionsUnderOrgCode ���ݵ�˰���ػ��Ż�ú���Ա���ͻ�ȡ˰����Ա����(�����������ص���Ա)
	 * ����ʼ�������б�ʹ�õķ���
	 * 
	 * @param orgCode
	 *            String �������ش���
	 * @param emptype
	 *            String ˰����Ա���ͣ���pubconstants�������� emptype Ϊ������ʱѡ����������˰����Ա
	 * @return Collection add by liu wanfu
	 */
	public Collection getEmpOptionUnderOrgCode(String orgCode, String emptype) {
		List list = new ArrayList();
		// Collection list = new ArrayList();
		// ��Ӧ��δѡ���˰���ز��� or ���Ŵ����д�
		if (TypeChecker.isEmpty(orgCode) || orgCode.length() != 10) {
			list.add(new OptionObject("", "          ", new CodTaxempcodeVO()));
			return list;
		}
		if ("000000".equals(orgCode.substring(4, 10))) {
			orgCode = orgCode.substring(0, 4);
		} else if ("0000".equals(orgCode.substring(6, 10))) {
			orgCode = orgCode.substring(0, 6);
		}

		list.add(new OptionObject("", " ", new CodTaxempcodeVO()));
		// ���˰����Ա����Ϊ�գ��������е�˰����Ա
		if (TypeChecker.isEmpty(emptype)) {
			Iterator iter = cachedList.iterator();
			iter.next();
			while (iter.hasNext()) {
				OptionObject optionObj = (OptionObject) iter.next();
				CodTaxempcodeVO vo = (CodTaxempcodeVO) optionObj.getObject();
				if (vo.getTaxorgcode().length() >= orgCode.length()
						&& orgCode.equals(vo.getTaxorgcode().substring(0,
								orgCode.length()))) {
					list.add(optionObj);
				}
			}
		} else {// ˰����Ա���Ͳ�Ϊ�գ�����˰����Ա���ͽ��й���
			Iterator iter = getTaxEmpCodeByEmpType(emptype).iterator();
			// iter.next();
			while (iter.hasNext()) {
				OptionObject optionObj = (OptionObject) iter.next();
				CodTaxempcodeVO vo = (CodTaxempcodeVO) optionObj.getObject();
				if (vo.getTaxorgcode().length() >= orgCode.length()
						&& orgCode.equals(vo.getTaxorgcode().substring(0,
								orgCode.length()))) {
					list.add(optionObj);
				}
			}
		}

		// if (list.size() > 0) {
		// OptionObject optionObj = new OptionObject("", " ",
		// new CodTaxempcodeVO());
		// list.add(0, optionObj);
		// }
		// else {
		// OptionObject optionObj = new OptionObject("", " ",
		// new CodTaxempcodeVO());
		// list.add(0, optionObj);
		// }
		return (Collection) list;
	}

	/**
	 * ������Ա���ͻ�ȡ˰����Ա ���÷�������������ֵ����
	 * 
	 * @param emptype
	 *            String ��Ա���ʹ��룬��pubConstants�ж��� add by liuwanfu
	 */
	public Collection getTaxEmpCodeByEmpType(String emptype) {
		List templist = new ArrayList();
		// ��Ա����Ϊ�գ�������е���Ա����
		if (TypeChecker.isEmpty(emptype)) {
			Iterator iter = cachedList.iterator();
			iter.next();
			while (iter.hasNext()) {
				templist.add(iter.next());
			}
			return templist;
		} else {
			Iterator iter = cachedList.iterator();
			while (iter.hasNext()) {
				OptionObject optionObj = (OptionObject) iter.next();
				CodTaxempcodeVO vo = (CodTaxempcodeVO) optionObj.getObject();
				if (PubConstants.TAXEMPCODE_AUTH_TYPE.equals(emptype)
						&& PubConstants.TAXEMPCODE_AUTH_FLAG.equals(vo
								.getAuthflag())) {
					templist.add(optionObj);
				} else if (PubConstants.TAXEMPCODE_LEVY_TYPE.equals(emptype)
						&& PubConstants.TAXEMPCODE_LEVY_FLAG.equals(vo
								.getLevyflag())) {
					templist.add(optionObj);
				} else if (PubConstants.TAXEMPCODE_TAXMANAGER_TYPE
						.equals(emptype)
						&& PubConstants.TAXEMPCODE_TAXMANAGER_FLAG.equals(vo
								.getTaxmanageflag())) {
					templist.add(optionObj);
				}
			}
		}
		return templist;
	}

	/**
	 * �����û�������Ȩ�޺�˰����Ա���ͻ�ȡ˰����Ա���룮
	 * 
	 * @param emptype
	 *            String add by liuwanfu
	 */
	public Collection getTaxEmpCodeWithDataRigths(String emptype) {
		// ��ȡ��������Ȩ��
		String[] datarightsarray = SystemUserAccessor.getInstance()
				.getCurrentModuleSelectRight();

		List reslist = new ArrayList();
		HashMap resmap = new HashMap();
		List typefilterlist = (List) this.getTaxEmpCodeByEmpType(emptype);
		// ʡ��Ȩ�޷������з������͵�˰����Ա
		if (datarightsarray == null) {
			reslist = (List) typefilterlist;
			reslist.add(0, new OptionObject("", " ", new CodTaxempcodeVO()));
			return reslist;
		}
		// Ȩ�޲�Ϊ�գ�����Ȩ�޶��Ѿ��������ͽ��й��˵��б���в���
		for (int a = 0; a < datarightsarray.length; a++) {
			String rightstr = datarightsarray[a];
			log.debug("emptype:" + emptype);
			log.debug("rightstr:" + rightstr);
			int rightstrlength = rightstr.length();
			for (int i = 0; i < typefilterlist.size(); i++) {
				OptionObject optionObj = (OptionObject) typefilterlist.get(i);
				CodTaxempcodeVO vo = (CodTaxempcodeVO) optionObj.getObject();
				if (!TypeChecker.isEmpty(vo.getTaxorgcode())) {
					if (vo.getTaxorgcode().length() >= rightstrlength
							&& rightstr.equals(vo.getTaxorgcode().substring(0,
									rightstrlength))) {
						resmap.put(vo.getTaxempcode(), optionObj);
					}
				}
			}
		}
		// ɾ��������е��ظ�����
		reslist = ListUtil.getSortedListfromMap(resmap);
		reslist.add(0, new OptionObject("", " ", new CodTaxempcodeVO()));
		/** @todo ��ȡ�����жϵ�ǰ�û��Ƿ���ר��Ա */

		return reslist;

	}

	/**
	 * ������Ա�����ȡ��Ա����
	 * 
	 * @param taxempcode
	 *            String ��Ա����
	 * @return CodTaxempcodeVO ��Ա����
	 */
	public static CodTaxempcodeVO getTaxEmpTaxempcodeVOByEmpCode(
			String taxempcode) {
		if (TypeChecker.isEmpty(taxempcode)) {
			return null;
		}
		Iterator it = cachedList.iterator();
		while (it.hasNext()) {
			OptionObject optionObj = (OptionObject) it.next();
			CodTaxempcodeVO vo = (CodTaxempcodeVO) optionObj.getObject();
			if (taxempcode.equals(vo.getTaxempcode())) {
				return vo;
			}
		}

		return null;

	}

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}
}
