package com.szgr.common.excel.importexcel;

import com.szgr.framework.core.ApplicationException;

public interface IProcessImportExcelObj {
	/**
	 * ����Excel����
	 * @param obj
	 */
    public void processExcelObj(Object obj) throws ApplicationException;
}
