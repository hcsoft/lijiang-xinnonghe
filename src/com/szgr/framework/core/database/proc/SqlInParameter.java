package com.szgr.framework.core.database.proc;

public class SqlInParameter implements ISqlParameter {
	
	private final Object parameterValue;
	
	/**
	 * 
	 * @param index
	 *            参数的位置
	 * @param sqlType sql类型
	 * @param parameterType
	 *            参数的类型是in参数还是out参数
	 */
	public SqlInParameter(Object parameterValue) {
		this.parameterValue = parameterValue;
	}
	public Object getParameterValue() {
		return parameterValue;
	}

	public SqlParameterType getParameterType() {
		return SqlParameterType.IN;
	}
	
	public String toString(){
		return "参数值为【"+this.parameterValue+"】，参数类型为in参数";
	}
}
