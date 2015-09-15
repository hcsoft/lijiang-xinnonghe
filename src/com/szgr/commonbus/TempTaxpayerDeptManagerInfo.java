package com.szgr.commonbus;

import com.szgr.common.PropertyConfigurer.PropertyConfigurerAcesse;

public class TempTaxpayerDeptManagerInfo implements IDeptManagerInfo {
	
	private static final String DEPT_CODE = "temptaxorgcode";
	private static final String MANAGER_CODE = "temptaxmanagercode";
	
	
	public String getTaxdeptcode() {
		String taxdeptcode = (String)PropertyConfigurerAcesse.getContextProperty(DEPT_CODE);
		return taxdeptcode;
	}

	
	public String getTaxmanagercode() {
		String taxmanagercode = (String)PropertyConfigurerAcesse.getContextProperty(MANAGER_CODE);
		return taxmanagercode;
	}
   
}
