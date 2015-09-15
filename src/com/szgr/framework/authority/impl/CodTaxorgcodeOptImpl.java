package com.szgr.framework.authority.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.szgr.framework.authority.datarights.ListUtil;
import com.szgr.framework.authority.datarights.OptionObject;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.szgr.framework.cache.options.code.ICodeOption;
import com.szgr.framework.cache.service.CacheService;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

/**
 * ˰����ػ�ȡ���
 * Created by ant task OptionGen.
 * 
 */
@Component("codTaxorgcodeOptImpl")
@Scope("prototype")
@Transactional(rollbackFor = { Exception.class, Exception.class })
public class CodTaxorgcodeOptImpl {
	private static Logger log = Logger.getLogger(CodTaxorgcodeOptImpl.class);

	@Autowired
	HibernateTemplate hibernateTemplate;

	private static Map cachedMap = new HashMap();

	/**
	 * ��������д������ݵ�List
	 */
	private static List cachedList = new ArrayList();

	/**
	 * ��ȡ���еĴ���꣬����ҵ��ģ��Ӧͨ������������ʴ���������
	 * 
	 * @return Collection
	 */
	public Collection getOptions() {
		return this.cachedList;
	}

	public CodTaxorgcodeOptImpl() {
		this.initOptions();
	}

	/**
	 * ��ʼ��װ�ش����
	 * 
	 * @return Collection �������еĴ���ֵ
	 */
//	public void initOptions() {
//		List list = new ArrayList();
//		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
//		try {
//
//			if(this.codeOption==null){
//				this.codeOption = (ICodeOption)SpringContextUtil.getBean("com.szgr.cache.options.code.CodeOption");
//			}
//			List tmpList = this.codeOption.getTaxOrgsVOList();
//			for (Iterator iter = tmpList.iterator(); iter.hasNext();) {
//				CodTaxorgcodeVO vo = (CodTaxorgcodeVO) iter.next();
//				list.add(new OptionObject(vo.getTaxorgcode().toString(), vo
//						.getTaxorgshortname().toString(), vo));
//			}
//		} catch (Exception e) {
//			String errstr = "ȡ����[����_˰����ش���]����";
//			log.error(errstr, e);
//		}
//		this.cachedList = list;
//		System.out.println("cachedList===========" + this.cachedList.size());
//	}
	
	public void initOptions() {
		List list = new ArrayList();
		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
		List tmpList = CacheService.getCachelist("COD_TAXORGCODE");
		this.cachedList = tmpList;
	}

	/**
	 * �ӻ��ػ�������л���м�������
	 * 
	 * @param nameType
	 *            String �������ͣ���˰���ؼ�ƻ���ȫ��
	 * @param orgType
	 *            String �������ͣ�����������ܻ���������͵�
	 * @return Collection
	 */
	public Collection getTaxsuperOrgCodeOptions(String nameType, String orgType) {

		return getClassedTaxorgcodeWithDataRights(PubConstants.TAXORGCLASS_SUP,
				nameType, orgType);

	}

	/**
	 * �ӻ��ػ�������л���ؼ�������
	 * 
	 * @param nameType
	 *            String �������ͣ���ƻ���ȫ��
	 * @param orgType
	 *            String �������ͣ�
	 * @return Collection
	 */
	public Collection getTaxOrgCodeOptions(String nameType, String orgType) {

		return getClassedTaxorgcodeWithDataRights(PubConstants.TAXORGCLASS_ORG,
				nameType, orgType);

	}

	/**
	 * �ӻ��ػ�������л�����ܵ�˰����
	 * 
	 * @param orgType
	 *            String
	 * @return Collection �����б�����ʹ��
	 */
	public Collection getTaxDeptCodeOptions(String nameType, String orgType) {

		return getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_DEPT, nameType, orgType);
	}

	/**
	 * ���ݻ��ش����û���VO
	 * 
	 * @param taxOrgCode
	 *            String
	 * @return CodTaxorgcodeVO
	 */
	public CodTaxorgcodeVO getTaxOrgVO(String taxOrgCode) {

		for (Iterator iter = cachedList.iterator(); iter.hasNext();) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (taxOrgCode.equals(vo.getTaxorgcode())) {
				return vo;
			}
		}
		return null;
	}

	/**
	 * getEmpOptionsByOrgCode �������м���˰���ػ����������˰����ѡ���б�
	 * 
	 * @param superOrgCode
	 *            String ���м����ش���
	 * @return Collection
	 */
	public Collection getOrgOptionBySupCode(String superOrgCode) {
		Collection list = new ArrayList();
		// ��Ӧ��ȡ��ѡ�����е�˰����
		if ("".equals(superOrgCode)) {
			list.add(new OptionObject("", "����ѡ�����е�˰����", new CodTaxorgcodeVO()));
			return list;
		}
		// ������Option�б�
		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
		/** @todo modifybyliuwanfu */
		List orgList = this.cachedList;
		Iterator iter = orgList.iterator();
		// ������һ����ѡ��
		iter.next();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (superOrgCode.equals(vo.getParentId())
					&& PubConstants.TAXORGCLASS_ORG.equals(vo.getOrgclass())
					&& PubConstants.TAXORGANIZATION.equals(vo.getOrgtype())) {
				list.add(optionObj);
			}
		}
		return list;
	}

	/**
	 * getOrgOptionBySupCodeWithDataRights �������м���˰���ػ����������˰����ѡ���б���Ȩ�޿��ƣ�
	 * 
	 * @param superOrgCode
	 *            String ���м����ش���
	 * @return Collection add by caoyun
	 */
	public Collection getOrgOptionBySupCodeWithDataRights(String superOrgCode) {
		// ���Ȩ�޷�Χ�ڵ���������������ѡ���б�
		List orgList = (List) getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_ORG, PubConstants.TAXORGNAME_SHORT,
				PubConstants.TAXORGANIZATION);

		// ����������Option�б�
		Iterator iter = orgList.iterator();
		List list = new ArrayList();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (null == vo.getTaxorgcode()
					|| superOrgCode.equals(vo.getParentId())) {
				list.add(optionObj);
			}
		}
		return list;
	}

	/**
	 * getEmpOptionsByOrgCode ������������˰���ػ�����ܵ�˰����ѡ���б�
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection
	 */
	public Collection getDeptOptionByOrgCode(String orgCode) {
		Collection list = new ArrayList();
		// ��Ӧ��ȡ��ѡ����������˰����
		if ("".equals(orgCode)) {
			list
					.add(new OptionObject("", "����ѡ����������˰����",
							new CodTaxorgcodeVO()));
			return list;
		}

		// ������Option�б�
		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
		List deptList = this.cachedList;
		Iterator iter = deptList.iterator();
		// ������һ����ѡ��
		iter.next();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (orgCode.equals(vo.getParentId())
					&& PubConstants.TAXORGCLASS_DEPT.equals(vo.getOrgclass())
					&& PubConstants.TAXORGANIZATION.equals(vo.getOrgtype())) {
				list.add(optionObj);
			}
		}
		return list;
	}

	/**
	 * getDeptOptionByOrgCodeWithDataRights ������������˰���ػ�����ܵ�˰����ѡ���б���Ȩ�޿��ƣ�
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection add by caoyun
	 */
	public Collection getDeptOptionByOrgCodeWithDataRights(String orgCode) {
		// ���Ȩ�޷�Χ�ڵ��������ܵ�˰����ѡ���б�
		List deptList = (List) getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_DEPT, PubConstants.TAXORGNAME_SHORT,
				PubConstants.TAXORGANIZATION);

		// ����������Option�б�
		Iterator iter = deptList.iterator();
		LinkedList list = new LinkedList();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (null == vo.getTaxorgcode() || orgCode.equals(vo.getParentId())) {
				list.add(optionObj);
			}
		}
		return list;
	}

	/**
	 * getDeptOptionByOrgCode �������м���˰���ػ�����ܵ�˰����ѡ���б�
	 * 
	 * @param supCode
	 *            String
	 * @return Collection add by caoyun
	 */
	public Collection getDeptOptionBySupCode(String supCode) {
		// ���Ȩ�޷�Χ�ڵ��������ܵ�˰����ѡ���б�
		List deptList = (List) getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_DEPT, PubConstants.TAXORGNAME_SHORT,
				PubConstants.TAXORGANIZATION);

		// ����������Option�б�
		Iterator iter = deptList.iterator();
		LinkedList list = new LinkedList();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (null != vo.getTaxorgcode()
					&& supCode.substring(0, 4).equals(
							vo.getTaxorgcode().substring(0, 4))) {
				list.add(optionObj);
			}
		}
		if (list.size() > 1) {
			list.add(0, new OptionObject("", "          ",
					new CodTaxorgcodeVO()));
		}
		return list;
	}

	/**
	 * ����ϼ���˰���ص�ѡ���б�ֻ��һ��ѡ�
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection
	 */
	public Collection getUpperOptionByOrgCode(String orgCode) {
		if (orgCode.length() != 10) {
			log.error("����Ļ��ش���");
			return null;
		}
		Collection thisOrg = this.getSingleOptionByOrgCode(orgCode);
		Iterator iter = thisOrg.iterator();
		if (!iter.hasNext()) {
			log.error("����Ļ��ش���");
			return null;
		}
		OptionObject thisObj = (OptionObject) iter.next();
		CodTaxorgcodeVO thisVO = (CodTaxorgcodeVO) thisObj.getObject();
		// ʡ�������ؿռ���
		if (PubConstants.TAXORGCLASS_PRO.equals(thisVO.getOrgclass())) {
			Collection list = new ArrayList();
			list.add(new OptionObject("", " ", new CodTaxorgcodeVO()));
			return list;
		}
		// �м�
		if (PubConstants.TAXORGCLASS_SUP.equals(thisVO.getOrgclass())) {
			return thisOrg;
		}
		// �ؼ� or �־�
		return getSingleOptionByOrgCode(thisVO.getParentId());
	}

	/**
	 * ���ݻ��ش����ȡ�û��ص��¼�����
	 * 
	 * @param orgCode
	 *            String ���ش���
	 * @return Collection
	 */
	public Collection getLowwerOptionByOrgCode(String orgCode) {
		if (null == orgCode || orgCode.length() != 10) {
			log.error("����Ļ��ش���");
			return null;
		}
		Collection thisOrg = this.getSingleOptionByOrgCode(orgCode);
		Iterator iter = thisOrg.iterator();
		if (!iter.hasNext()) {
			log.error("����Ļ��ش���");
			return null;
		}
		OptionObject thisObj = (OptionObject) iter.next();
		CodTaxorgcodeVO thisVO = (CodTaxorgcodeVO) thisObj.getObject();
		// ʡ��
		if (PubConstants.TAXORGCLASS_PRO.equals(thisVO.getOrgclass())) {
			// ʡ��Ȩ�ޣ��������е����м���˰����
			return getClassedTaxorgcodeWithOutDataRights(
					PubConstants.TAXORGCLASS_SUP,
					PubConstants.TAXORGNAME_SHORT, PubConstants.TAXORGANIZATION);
		}
		// �м�
		if (PubConstants.TAXORGCLASS_SUP.equals(thisVO.getOrgclass())) {
			return getOrgOptionBySupCode(orgCode);
		}
		// �ؼ�
		if (PubConstants.TAXORGCLASS_ORG.equals(thisVO.getOrgclass())) {
			return getDeptOptionByOrgCode(orgCode);
		}
		// �־֣����ؿռ���
		if (PubConstants.TAXORGCLASS_DEPT.equals(thisVO.getOrgclass())) {
			Collection list = new ArrayList();
			list.add(new OptionObject("", " ", new CodTaxorgcodeVO()));
			return list;
		}
		return null;
	}

	/**
	 * ���ݻ��ش����øû���OptionObject
	 * 
	 * @param orgCode
	 *            String ���ش���
	 * @return Collection
	 */
	public static Collection getSingleOptionByOrgCode(String orgCode) {
		if (null == orgCode || orgCode.length() != 10) {
			log.error("getSingleOptionByOrgCode(����Ļ��ش���)");
			return null;
		}
		Collection list = new ArrayList();
		List deptList = cachedList;
		Iterator iter = deptList.iterator();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (orgCode.equals(vo.getTaxorgcode())) {
				list.add(optionObj);
				return list;
			}
		}
		return null;
	}

	/**
	 * ��ȡĳ������Ļ��ش���
	 */
	/**
	 * ���ݻ��ؼ���ͻ������ͻ�ȡ��˰���ش��룬û����������Ȩ�޹���,����ȡ���
	 * 
	 * @param orgclass
	 *            String ������������
	 * @param orgtype
	 *            String ��������
	 * @param nametype
	 *            String �������� add by liuwanfu
	 */
	public Collection getClassedTaxorgcodeWithOutDataRights(String orgclass,
			String nametype, String orgtype) {
		LinkedList list = new LinkedList();
		Iterator iter = this.cachedList.iterator();
		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			// PubConstants.TAXORGCLASS_SUP���ص���������Ϊ�м�
			if (orgtype.equals(vo.getOrgtype())
					&& orgclass.equals(vo.getOrgclass())) {
				// �������Ͳ���Ϊ���ʱȡ���
				if (PubConstants.TAXORGNAME_SHORT.equals(nametype)) {
					list.add(new OptionObject(vo.getTaxorgcode().toString(), vo
							.getTaxorgshortname().toString(), vo));
				} else {
					list.add(new OptionObject(vo.getTaxorgcode().toString(), vo
							.getTaxorgname().toString(), vo));

				}
			}

		}
		return list;
	}

	/**
	 * ���ݻ�����������ͻ������ͺ�ƽ̨���ص�����Ȩ�޲�ѯ�����еĵ�˰����
	 * 
	 * @param orgclass
	 *            String ������������
	 * @param orgtype
	 *            String ��������
	 * @param nametype
	 *            String ��������
	 * @return Collection ��ѯ���Ľ���� add by liuwanfu
	 */
	private Collection getClassedTaxorgcodeWithDataRights(String orgclass,
			String nametype, String orgtype) {
		HashMap resmap = new HashMap();
		// List templist = new LinkedList();
		// ��ȡ�û���ǰ�������б�Ȩ�����顡
		String[] daterightsarray = SystemUserAccessor.getInstance()
				.getCurrentModuleSelectRight();
//		---------------------
//		532326
//		---------------------
		if (daterightsarray == null) {
			// ����Ϊ��,ʡ��Ȩ��,�������еĴ����
			return getClassedTaxorgcodeWithOutDataRights(orgclass, nametype,
					orgtype);
		}
		// ��ʼ����Ȩ������Ե�˰���ش�����й���

		/** @todo ���������У�������10 �ķֱ��ж����ж��Ƿ�Ҫ��ѡ�������б��� */
		// List templist = new ArrayList();
		for (int a = 0; a < daterightsarray.length; a++) {
			String tempcode = daterightsarray[a];
			log.debug("+++++++++++++++++++++++++++++++�����������Ȩ��Ϊ:" + tempcode);
			int length = tempcode.length();
			for (int b = 1; b < this.cachedList.size(); b++) {
				OptionObject optionObj = (OptionObject) cachedList.get(b);
				CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
				// log.debug( vo.toString());
				// log.debug("orgtype:"+orgtype);
				// log.debug("orgclass:"+orgclass);
				// log.debug("---------------------------------��λ�������Ȩ��Ϊ��"+vo.getTaxorgcode().substring(0,
				// length));
				if (orgtype.equals(vo.getOrgtype())
						&& orgclass.equals(vo.getOrgclass())) {
					// log.debug("---------------------------------��λ������Ȩ��Ϊ��"+vo.getTaxorgcode().substring(0,
					// length));
					if (PubConstants.TAXORGCLASS_SUP.equals(orgclass)
							&& tempcode.substring(0, 4).equals(
									vo.getTaxorgcode().substring(0, 4))) {
						// ��������Ϊ���
						if (PubConstants.TAXORGNAME_SHORT.equals(nametype)) {
							resmap.put(vo.getTaxorgcode(), new OptionObject(vo
									.getTaxorgcode().toString(), vo
									.getTaxorgshortname().toString(), vo));
						} else {
							resmap.put(vo.getTaxorgcode(), new OptionObject(vo
									.getTaxorgcode().toString(), vo
									.getTaxorgname().toString(), vo));
						}
					} else if (PubConstants.TAXORGCLASS_ORG.equals(orgclass)
							&& ((length < 7 && tempcode.equals(vo
									.getTaxorgcode().substring(0, length))) || (length > 7 && tempcode
									.substring(0, 6).equals(
											vo.getTaxorgcode().substring(0, 6))))) {
						// ��������Ϊ��� ��������˰����
						if (PubConstants.TAXORGNAME_SHORT.equals(nametype)) {
							resmap.put(vo.getTaxorgcode(), new OptionObject(vo
									.getTaxorgcode().toString(), vo
									.getTaxorgshortname().toString(), vo));
						} else {
							resmap.put(vo.getTaxorgcode(), new OptionObject(vo
									.getTaxorgcode().toString(), vo
									.getTaxorgname().toString(), vo));
						}
					} else if (PubConstants.TAXORGCLASS_DEPT.equals(orgclass)
							&& tempcode.equals(vo.getTaxorgcode().substring(0,
									length))) {
						// ��������Ϊ���
						if (PubConstants.TAXORGNAME_SHORT.equals(nametype)) {
							resmap.put(vo.getTaxorgcode(), new OptionObject(vo
									.getTaxorgcode().toString(), vo
									.getTaxorgshortname().toString(), vo));
						} else {
							resmap.put(vo.getTaxorgcode(), new OptionObject(vo
									.getTaxorgcode().toString(), vo
									.getTaxorgname().toString(), vo));
						}
					}
				}
			}
		}
		// templist = ListUtil.getNoRepeatedList(templist);
		// templist = getNorepeatedTaxOrgCodeList(templist);
		List reslist = ListUtil.getSortedListfromMap(resmap);

		if (hasNoLimit(daterightsarray, orgclass)) {
			reslist.add(0, new OptionObject("", "          ",
					new CodTaxorgcodeVO()));
		}
		return (Collection) reslist;
	}

	/**
	 * �ж������б����Ƿ�����ѡ�񣨲����ƣ���������
	 * 
	 * @param rightarray
	 *            String
	 * @param length
	 *            int
	 * @return boolean
	 */
	private boolean hasNoLimit(String[] rightarray, String orgclass) {
		// ���м���˰���أ�ʡ��rightarrayΪ�����죬ֱ�ӷ��������б�
		if (PubConstants.TAXORGCLASS_SUP.equals(orgclass)) {
			return false;
		}
		// ����Ϊ�����ֵ�˰����
		else if (PubConstants.TAXORGCLASS_ORG.equals(orgclass)) {
			for (int a = 0; a < rightarray.length; a++) {
				// Ȩ���䵽����һ���������ֱ�ѡ,�����Ƿ־�Ȩ��
				if (rightarray[a].length() == 6 || rightarray[a].length() == 10) {
					return false;
				}
			}
		} else if (PubConstants.TAXORGCLASS_DEPT.equals(orgclass)) {
			// ����Ϊ�־���
			for (int a = 0; a < rightarray.length; a++) {
				// Ȩ���䵽�־���һ�����־�����ѡ
				if (rightarray[a].length() == 10) {
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * ��ȡ�����ֵ�˰���ش���,������Ȩ��
	 * 
	 * @param nameType
	 *            String ��������
	 * @param orgType
	 *            String ��������
	 * @return Collection add by liuwanfu
	 */
	public Collection getTaxOrgCodeOptionsWithOutDataRights(String nameType,
			String orgType) {
		LinkedList list = new LinkedList();
		Iterator iter = cachedList.iterator();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (orgType.equals(vo.getOrgtype())
					&& PubConstants.TAXORGCLASS_ORG.equals(vo.getOrgclass())) {
				if (PubConstants.TAXORGNAME_SHORT.equals(nameType)) {
					list.add(new OptionObject(vo.getTaxorgcode().toString(), vo
							.getTaxorgshortname().toString(), vo));
				} else {
					list.add(new OptionObject(vo.getTaxorgcode().toString(), vo
							.getTaxorgname().toString(), vo));
				}
			}
		}
		if (list.size() > 1) {
			OptionObject optionObj = new OptionObject("", "��ѡ��",
					new CodTaxorgcodeVO());
			list.add(0, optionObj);
		}
		return (Collection) list;
	}

	/**
	 * ��ȡ���е�˰����,��������Ȩ��
	 * 
	 * @param nameType
	 *            String ��������
	 * @param orgType
	 *            String ��������
	 * @return Collection add by liuwanfu
	 */
	public Collection getTaxsuperOrgCodeOptionsWithOutDataRights(
			String nameType, String orgType) {
		LinkedList list = new LinkedList();
		Iterator iter = cachedList.iterator();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (orgType.equals(vo.getOrgtype())
					&& PubConstants.TAXORGCLASS_SUP.equals(vo.getOrgclass())) {
				if (PubConstants.TAXORGNAME_SHORT.equals(nameType)) {
					list.add(new OptionObject(vo.getTaxorgcode().toString(), vo
							.getTaxorgshortname().toString(), vo));
				} else {
					list.add(new OptionObject(vo.getTaxorgcode().toString(), vo
							.getTaxorgname().toString(), vo));
				}
			}
		}
		if (list.size() > 0) {
			OptionObject optionObj = new OptionObject("", "��ѡ��",
					new CodTaxorgcodeVO());
			list.add(0, optionObj);
		}
		return (Collection) list;

	}

	/**
	 * �ӻ��ػ�������л�����ܵ�˰����,��������Ȩ��
	 * 
	 * @param orgType
	 *            String
	 * @return Collection �����б�����ʹ�� add by liuwanfu
	 */
	public Collection getTaxDeptCodeOptionsWithOutDataRights(String nameType,
			String orgType) {
		// LinkedList list = new LinkedList();
		HashMap resmap = new HashMap();

		Iterator iter = cachedList.iterator();
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			if (orgType.equals(vo.getOrgtype())
					&& PubConstants.TAXORGCLASS_DEPT.equals(vo.getOrgclass())) {
				if (PubConstants.TAXORGNAME_SHORT.equals(nameType)) {
					resmap.put(vo.getTaxorgcode(), optionObj);
				} else {
					resmap.put(vo.getTaxorgcode(), optionObj);

				}
			}
		}
		List oplist = ListUtil.getSortedListfromMap(resmap);
		if (oplist.size() > 1) {
			OptionObject optionObj = new OptionObject("", "��ѡ��",
					new CodTaxorgcodeVO());
			oplist.add(0, optionObj);
		}
		return (Collection) oplist;
	}

	/**
	 * �������ջ��ش����ȡ���ջ�������
	 * 
	 * @param taxorgcode
	 * @return
	 */
	public static String getTaxorgname(String taxorgcode) {
		String taxorgname = "";
		for (int i = 0; i < cachedList.size(); i++) {
			OptionObject option = (OptionObject) cachedList.get(i);
			if (option.getKey().equals(taxorgcode)) {
				taxorgname = option.getValue();
				System.out.println(i);
			}
		}
		return taxorgname;
	}

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}
}
