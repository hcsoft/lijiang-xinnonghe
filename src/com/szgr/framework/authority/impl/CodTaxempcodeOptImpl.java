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
	 * 缓存的所有代码数据的List
	 */
	private static List cachedList = new ArrayList();

	/**
	 * 获得所有的税务人员代码
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
	 * 从数据库中初始装载代码表
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
	 * 从缓存中取所有税务人员
	 * 
	 * @return Collection
	 */
	public Collection getTaxEmpCodeOptions() {
		Collection list = cachedList;
		return list;
	}

	/**
	 * getEmpOptionsByOrgCode 根据地税机关或部门获得税务管理员选项列表 供联动使用
	 * 
	 * @param orgCode
	 *            String
	 * @return Collection
	 */
	public Collection getEmpOptionByOrgCode(String orgCode) {
		return getEmpOptionByOrgCode(orgCode, null);
	}

	/**
	 * getEmpOptionsByOrgCode 根据地税机关或部门获得和人员类型获取税务人员代码(机关直属) 供联动使用的方法
	 * 
	 * @param orgCode
	 *            String 所属机关代码
	 * @param emptype
	 *            String 税务人员类型，见pubconstants常量定义 emptype 为ｎｕｌｌ时选择所有类别的税务人员
	 * @return Collection add by liu wanfu
	 */
	public Collection getEmpOptionByOrgCode(String orgCode, String emptype) {
		List list = new ArrayList();
		// Collection list = new ArrayList();
		// 对应于取消选择县区级地税机关
		if ("".equals(orgCode)) {
			list.add(new OptionObject("", "请先选择地税机关部门", new CodTaxempcodeVO()));
			return list;
		}

		list.add(new OptionObject("", " ", new CodTaxempcodeVO()));
		// 如果税务人员类型为空，返回所有的税务人员
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
		} else {// 税务人员类型不为空，根据税务人员类型进行过滤
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
	 * getEmpOptionsUnderOrgCode 根据地税机关或部门获得和人员类型获取税务人员代码(包含下属机关的人员)
	 * 供初始化下拉列表使用的方法
	 * 
	 * @param orgCode
	 *            String 所属机关代码
	 * @param emptype
	 *            String 税务人员类型，见pubconstants常量定义 emptype 为ｎｕｌｌ时选择所有类别的税务人员
	 * @return Collection add by liu wanfu
	 */
	public Collection getEmpOptionUnderOrgCode(String orgCode, String emptype) {
		List list = new ArrayList();
		// Collection list = new ArrayList();
		// 对应于未选择地税机关部门 or 部门代码有错
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
		// 如果税务人员类型为空，返回所有的税务人员
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
		} else {// 税务人员类型不为空，根据税务人员类型进行过滤
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
	 * 根据人员类型获取税务人员 公用方法，不带不限值方法
	 * 
	 * @param emptype
	 *            String 人员类型代码，在pubConstants中定义 add by liuwanfu
	 */
	public Collection getTaxEmpCodeByEmpType(String emptype) {
		List templist = new ArrayList();
		// 人员类型为空，输出所有的人员代码
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
	 * 根据用户的数据权限和税务人员类型获取税务人员代码．
	 * 
	 * @param emptype
	 *            String add by liuwanfu
	 */
	public Collection getTaxEmpCodeWithDataRigths(String emptype) {
		// 获取下拉数据权限
		String[] datarightsarray = SystemUserAccessor.getInstance()
				.getCurrentModuleSelectRight();

		List reslist = new ArrayList();
		HashMap resmap = new HashMap();
		List typefilterlist = (List) this.getTaxEmpCodeByEmpType(emptype);
		// 省局权限返回所有符合类型的税务人员
		if (datarightsarray == null) {
			reslist = (List) typefilterlist;
			reslist.add(0, new OptionObject("", " ", new CodTaxempcodeVO()));
			return reslist;
		}
		// 权限不为空，根据权限对已经根据类型进行过滤的列表进行操作
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
		// 删除结果集中的重复对象
		reslist = ListUtil.getSortedListfromMap(resmap);
		reslist.add(0, new OptionObject("", " ", new CodTaxempcodeVO()));
		/** @todo 读取参数判断当前用户是否是专管员 */

		return reslist;

	}

	/**
	 * 根据人员代码获取人员对象
	 * 
	 * @param taxempcode
	 *            String 人员代码
	 * @return CodTaxempcodeVO 人员对象
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
