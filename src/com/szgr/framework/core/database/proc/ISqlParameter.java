package com.szgr.framework.core.database.proc;

/**
 * 
 * <p>
 * Title: ISqlParameter.java
 * </p>
 * <p>
 * Description: 参数接口
 * </p>
 * <p>
 * Copyright: Copyright (c) 2013
 * </p>
 * <p>
 * Company: szgr
 * </p>
 * @author xuhong
 * @date 2013-11-4
 * @version 1.0
 */
public interface ISqlParameter {
	/**
	 * 
	 * @return  获取参数类型
	 */
	public SqlParameterType getParameterType();
}
