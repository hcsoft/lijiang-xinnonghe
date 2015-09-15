package com.szgr.framework.core;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.szgr.framework.authority.datarights.OptionObject;
import com.szgr.framework.authority.datarights.SystemUserAccessor;
import com.thtf.ynds.vo.CodTaxorgcodeVO;

public class CurrentUserInfo {
    private static final CurrentUserInfo INSTANCE = new CurrentUserInfo();
    private static final String ROOT  = "-1";
    private SystemUserAccessor systemUserAccessor;

    private CurrentUserInfo(){
    	this.systemUserAccessor = SystemUserAccessor.getInstance();
    	
    }
    /**
     * 获取县级机关、市级机关、省级机关
     * @return
     */
    public List<OptionObject> getOrgInfo(){
    	List<OptionObject> list = new ArrayList<OptionObject>();
    	java.util.Set<OptionObject> set = new java.util.HashSet<OptionObject>();
    	CodTaxorgcodeVO orgcodeVo = this.systemUserAccessor.getUserTaxOrgVO();
    	String parentId = orgcodeVo.getParentId();
    	System.out.println(parentId);
    	while(!parentId.equals(ROOT)){
    		orgcodeVo = ApplicationContextUtils.getHibernateTemplate().get(CodTaxorgcodeVO.class,parentId); 
    		if(orgcodeVo != null){
    			OptionObject oo = new OptionObject(orgcodeVo.getTaxorgcode(),orgcodeVo.getTaxorgname());
    			set.add(oo);
    		}
    		parentId = orgcodeVo.getParentId();
    		System.out.println(parentId);
    	}
    	if(parentId.equals(ROOT)){
    		OptionObject oo = new OptionObject(orgcodeVo.getTaxorgcode(),orgcodeVo.getTaxorgname());
    		set.add(oo);
    	}
    	list.addAll(set);
    	Collections.sort(list,new Comparator<OptionObject>() {
			
			public int compare(OptionObject o1, OptionObject o2) {
				return o1.getKey().compareTo(o2.getKey());
			}
		});
    	return list;
    }
    public static CurrentUserInfo getInstance(){
    	return INSTANCE;
    }
}
