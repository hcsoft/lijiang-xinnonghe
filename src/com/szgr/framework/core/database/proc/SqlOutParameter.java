package com.szgr.framework.core.database.proc;

public class SqlOutParameter implements ISqlParameter {
	
	private final int sqlType;

	public SqlOutParameter(int sqlType) {
		this.sqlType = sqlType;
	}
	public int getSqlType() {
		return sqlType;
	}
	
	public String toString(){
		return "参数类型为out参数,SqlType为"+sqlType;
	}
	
	public SqlParameterType getParameterType() {
		return SqlParameterType.OUT;
	}
}
