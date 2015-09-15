package com.szgr.framework.core.database.proc;

public class SqlInParameter implements ISqlParameter {
	
	private final Object parameterValue;
	
	/**
	 * 
	 * @param index
	 *            ������λ��
	 * @param sqlType sql����
	 * @param parameterType
	 *            ������������in��������out����
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
		return "����ֵΪ��"+this.parameterValue+"������������Ϊin����";
	}
}
