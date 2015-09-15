package com.szgr.common.excel.importexcel;

import com.szgr.framework.core.ApplicationException;

public interface IProcessImportExcelObj {
	/**
	 * 处理Excel对象
	 * @param obj
	 */
    public void processExcelObj(Object obj) throws ApplicationException;
}
