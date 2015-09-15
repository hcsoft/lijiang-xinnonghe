package com.szgr.framework.cache.options.code;

import java.util.List;

import com.szgr.framework.authority.datarights.OptionObject;

public interface ICodeOption {

	public List getCodeVOComboxList(Class voClass, String keyfield,
			String valuefield, String where);

	public List<OptionObject> genCodeVOCache(String codetablename,
			String codekey, String codevalue, String where,Class voClass);
	
	public List getTaxOrgsVOList();

	public List getTaxEmpsVOList();

}
