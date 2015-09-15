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
 * 税务机关获取组件
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
	 * 缓存的所有代码数据的List
	 */
	private static List cachedList = new ArrayList();

	/**
	 * 获取所有的代码标，其它业务模块应通过这个方法访问代码表缓存对象．
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
	 * 初始化装载代码表
	 * 
	 * @return Collection 返回所有的代码值
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
//			String errstr = "取所有[代码_税务机关代码]出错";
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
	 * 从机关缓存代码中获得市级类别机关
	 * 
	 * @param nameType
	 *            String 名称类型，地税机关简称还是全称
	 * @param orgType
	 *            String 机关类型，如内设机构＼稽查机关类型等
	 * @return Collection
	 */
	public Collection getTaxsuperOrgCodeOptions(String nameType, String orgType) {

		return getClassedTaxorgcodeWithDataRights(PubConstants.TAXORGCLASS_SUP,
				nameType, orgType);

	}

	/**
	 * 从机关缓存代码中获得县级类别机关
	 * 
	 * @param nameType
	 *            String 名称类型，简称还是全称
	 * @param orgType
	 *            String 机关类型，
	 * @return Collection
	 */
	public Collection getTaxOrgCodeOptions(String nameType, String orgType) {

		return getClassedTaxorgcodeWithDataRights(PubConstants.TAXORGCLASS_ORG,
				nameType, orgType);

	}

	/**
	 * 从机关缓存代码中获得主管地税部门
	 * 
	 * @param orgType
	 *            String
	 * @return Collection 下拉列表联动使用
	 */
	public Collection getTaxDeptCodeOptions(String nameType, String orgType) {

		return getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_DEPT, nameType, orgType);
	}

	/**
	 * 根据机关代码获得机关VO
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
	 * getEmpOptionsByOrgCode 根据州市级地税机关获得县区级地税机关选项列表
	 * 
	 * @param superOrgCode
	 *            String 州市级机关代码
	 * @return Collection
	 */
	public Collection getOrgOptionBySupCode(String superOrgCode) {
		Collection list = new ArrayList();
		// 对应于取消选择州市地税机关
		if ("".equals(superOrgCode)) {
			list.add(new OptionObject("", "请先选择州市地税机关", new CodTaxorgcodeVO()));
			return list;
		}
		// 新生成Option列表
		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
		/** @todo modifybyliuwanfu */
		List orgList = this.cachedList;
		Iterator iter = orgList.iterator();
		// 跳过第一个空选项
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
	 * getOrgOptionBySupCodeWithDataRights 根据州市级地税机关获得县区级地税机关选项列表（带权限控制）
	 * 
	 * @param superOrgCode
	 *            String 州市级机关代码
	 * @return Collection add by caoyun
	 */
	public Collection getOrgOptionBySupCodeWithDataRights(String superOrgCode) {
		// 获得权限范围内的所有县区级机关选项列表
		List orgList = (List) getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_ORG, PubConstants.TAXORGNAME_SHORT,
				PubConstants.TAXORGANIZATION);

		// 过滤生成新Option列表
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
	 * getEmpOptionsByOrgCode 根据县区级地税机关获得主管地税部门选项列表
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection
	 */
	public Collection getDeptOptionByOrgCode(String orgCode) {
		Collection list = new ArrayList();
		// 对应于取消选择县区级地税机关
		if ("".equals(orgCode)) {
			list
					.add(new OptionObject("", "请先选择县区级地税机关",
							new CodTaxorgcodeVO()));
			return list;
		}

		// 新生成Option列表
		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
		List deptList = this.cachedList;
		Iterator iter = deptList.iterator();
		// 跳过第一个空选项
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
	 * getDeptOptionByOrgCodeWithDataRights 根据县区级地税机关获得主管地税部门选项列表（带权限控制）
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection add by caoyun
	 */
	public Collection getDeptOptionByOrgCodeWithDataRights(String orgCode) {
		// 获得权限范围内的所有主管地税部门选项列表
		List deptList = (List) getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_DEPT, PubConstants.TAXORGNAME_SHORT,
				PubConstants.TAXORGANIZATION);

		// 过滤生成新Option列表
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
	 * getDeptOptionByOrgCode 根据州市级地税机关获得主管地税部门选项列表
	 * 
	 * @param supCode
	 *            String
	 * @return Collection add by caoyun
	 */
	public Collection getDeptOptionBySupCode(String supCode) {
		// 获得权限范围内的所有主管地税部门选项列表
		List deptList = (List) getClassedTaxorgcodeWithDataRights(
				PubConstants.TAXORGCLASS_DEPT, PubConstants.TAXORGNAME_SHORT,
				PubConstants.TAXORGANIZATION);

		// 过滤生成新Option列表
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
	 * 获得上级地税机关的选项列表（只有一个选项）
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection
	 */
	public Collection getUpperOptionByOrgCode(String orgCode) {
		if (orgCode.length() != 10) {
			log.error("错误的机关代码");
			return null;
		}
		Collection thisOrg = this.getSingleOptionByOrgCode(orgCode);
		Iterator iter = thisOrg.iterator();
		if (!iter.hasNext()) {
			log.error("错误的机关代码");
			return null;
		}
		OptionObject thisObj = (OptionObject) iter.next();
		CodTaxorgcodeVO thisVO = (CodTaxorgcodeVO) thisObj.getObject();
		// 省级，返回空集合
		if (PubConstants.TAXORGCLASS_PRO.equals(thisVO.getOrgclass())) {
			Collection list = new ArrayList();
			list.add(new OptionObject("", " ", new CodTaxorgcodeVO()));
			return list;
		}
		// 市级
		if (PubConstants.TAXORGCLASS_SUP.equals(thisVO.getOrgclass())) {
			return thisOrg;
		}
		// 县级 or 分局
		return getSingleOptionByOrgCode(thisVO.getParentId());
	}

	/**
	 * 根据机关代码获取该机关的下级机关
	 * 
	 * @param orgCode
	 *            String 机关代码
	 * @return Collection
	 */
	public Collection getLowwerOptionByOrgCode(String orgCode) {
		if (null == orgCode || orgCode.length() != 10) {
			log.error("错误的机关代码");
			return null;
		}
		Collection thisOrg = this.getSingleOptionByOrgCode(orgCode);
		Iterator iter = thisOrg.iterator();
		if (!iter.hasNext()) {
			log.error("错误的机关代码");
			return null;
		}
		OptionObject thisObj = (OptionObject) iter.next();
		CodTaxorgcodeVO thisVO = (CodTaxorgcodeVO) thisObj.getObject();
		// 省级
		if (PubConstants.TAXORGCLASS_PRO.equals(thisVO.getOrgclass())) {
			// 省级权限，返回所有的州市级地税机关
			return getClassedTaxorgcodeWithOutDataRights(
					PubConstants.TAXORGCLASS_SUP,
					PubConstants.TAXORGNAME_SHORT, PubConstants.TAXORGANIZATION);
		}
		// 市级
		if (PubConstants.TAXORGCLASS_SUP.equals(thisVO.getOrgclass())) {
			return getOrgOptionBySupCode(orgCode);
		}
		// 县级
		if (PubConstants.TAXORGCLASS_ORG.equals(thisVO.getOrgclass())) {
			return getDeptOptionByOrgCode(orgCode);
		}
		// 分局，返回空集合
		if (PubConstants.TAXORGCLASS_DEPT.equals(thisVO.getOrgclass())) {
			Collection list = new ArrayList();
			list.add(new OptionObject("", " ", new CodTaxorgcodeVO()));
			return list;
		}
		return null;
	}

	/**
	 * 根据机关代码获得该机关OptionObject
	 * 
	 * @param orgCode
	 *            String 机关代码
	 * @return Collection
	 */
	public static Collection getSingleOptionByOrgCode(String orgCode) {
		if (null == orgCode || orgCode.length() != 10) {
			log.error("getSingleOptionByOrgCode(错误的机关代码)");
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
	 * 获取某个级别的机关代码
	 */
	/**
	 * 根据机关级别和机关类型获取地税机关代码，没有数据数据权限过滤,名称取简称
	 * 
	 * @param orgclass
	 *            String 机关行政级别
	 * @param orgtype
	 *            String 机关类型
	 * @param nametype
	 *            String 名称类型 add by liuwanfu
	 */
	public Collection getClassedTaxorgcodeWithOutDataRights(String orgclass,
			String nametype, String orgtype) {
		LinkedList list = new LinkedList();
		Iterator iter = this.cachedList.iterator();
		list.add(new OptionObject("", "          ", new CodTaxorgcodeVO()));
		while (iter.hasNext()) {
			OptionObject optionObj = (OptionObject) iter.next();
			CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
			// PubConstants.TAXORGCLASS_SUP机关的行政级别为市级
			if (orgtype.equals(vo.getOrgtype())
					&& orgclass.equals(vo.getOrgclass())) {
				// 名称类型参数为简称时取简称
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
	 * 根据机关行政级别和机关类型和平台加载的数据权限查询缓存中的地税机关
	 * 
	 * @param orgclass
	 *            String 机关行政级别
	 * @param orgtype
	 *            String 机关类型
	 * @param nametype
	 *            String 名称类型
	 * @return Collection 查询到的结果集 add by liuwanfu
	 */
	private Collection getClassedTaxorgcodeWithDataRights(String orgclass,
			String nametype, String orgtype) {
		HashMap resmap = new HashMap();
		// List templist = new LinkedList();
		// 获取用户单前的下拉列表权限数组　
		String[] daterightsarray = SystemUserAccessor.getInstance()
				.getCurrentModuleSelectRight();
//		---------------------
//		532326
//		---------------------
		if (daterightsarray == null) {
			// 数组为空,省局权限,返回所有的代码表
			return getClassedTaxorgcodeWithOutDataRights(orgclass, nametype,
					orgtype);
		}
		// 开始根据权限数组对地税机关代码进行过滤

		/** @todo 根据数组中４　６　10 的分别有多少判断是否要请选择下拉列表项 */
		// List templist = new ArrayList();
		for (int a = 0; a < daterightsarray.length; a++) {
			String tempcode = daterightsarray[a];
			log.debug("+++++++++++++++++++++++++++++++解析后的数据权限为:" + tempcode);
			int length = tempcode.length();
			for (int b = 1; b < this.cachedList.size(); b++) {
				OptionObject optionObj = (OptionObject) cachedList.get(b);
				CodTaxorgcodeVO vo = (CodTaxorgcodeVO) optionObj.getObject();
				// log.debug( vo.toString());
				// log.debug("orgtype:"+orgtype);
				// log.debug("orgclass:"+orgclass);
				// log.debug("---------------------------------截位后的数据权限为："+vo.getTaxorgcode().substring(0,
				// length));
				if (orgtype.equals(vo.getOrgtype())
						&& orgclass.equals(vo.getOrgclass())) {
					// log.debug("---------------------------------截位的数据权限为："+vo.getTaxorgcode().substring(0,
					// length));
					if (PubConstants.TAXORGCLASS_SUP.equals(orgclass)
							&& tempcode.substring(0, 4).equals(
									vo.getTaxorgcode().substring(0, 4))) {
						// 名称类型为简称
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
						// 名称类型为简称 县区级地税机关
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
						// 名称类型为简称
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
	 * 判断下拉列表中是否有请选择（不限制）的下拉项
	 * 
	 * @param rightarray
	 *            String
	 * @param length
	 *            int
	 * @return boolean
	 */
	private boolean hasNoLimit(String[] rightarray, String orgclass) {
		// 州市级地税机关，省局rightarray为ｎｕｌｌ，直接返回整个列表
		if (PubConstants.TAXORGCLASS_SUP.equals(orgclass)) {
			return false;
		}
		// 级别为县区局地税机关
		else if (PubConstants.TAXORGCLASS_ORG.equals(orgclass)) {
			for (int a = 0; a < rightarray.length; a++) {
				// 权限配到县区一级，县区局必选,或者是分局权限
				if (rightarray[a].length() == 6 || rightarray[a].length() == 10) {
					return false;
				}
			}
		} else if (PubConstants.TAXORGCLASS_DEPT.equals(orgclass)) {
			// 级别为分局所
			for (int a = 0; a < rightarray.length; a++) {
				// 权限配到分局所一级，分局所必选
				if (rightarray[a].length() == 10) {
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * 获取县区局地税机关代码,无数据权限
	 * 
	 * @param nameType
	 *            String 名称类型
	 * @param orgType
	 *            String 机关类型
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
			OptionObject optionObj = new OptionObject("", "请选择",
					new CodTaxorgcodeVO());
			list.add(0, optionObj);
		}
		return (Collection) list;
	}

	/**
	 * 获取州市地税机关,不带数据权限
	 * 
	 * @param nameType
	 *            String 名称类型
	 * @param orgType
	 *            String 机关类型
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
			OptionObject optionObj = new OptionObject("", "请选择",
					new CodTaxorgcodeVO());
			list.add(0, optionObj);
		}
		return (Collection) list;

	}

	/**
	 * 从机关缓存代码中获得主管地税部门,不带数据权限
	 * 
	 * @param orgType
	 *            String
	 * @return Collection 下拉列表联动使用 add by liuwanfu
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
			OptionObject optionObj = new OptionObject("", "请选择",
					new CodTaxorgcodeVO());
			oplist.add(0, optionObj);
		}
		return (Collection) oplist;
	}

	/**
	 * 根据征收机关代码获取征收机关名称
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
