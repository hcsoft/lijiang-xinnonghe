package com.szgr.framework.core.database.proc;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class ProcExecuteNoResult extends AbstractProcExecute{

	public ProcExecuteNoResult(String procName,List<ISqlParameter> list,boolean enableTransaction){
    	super(procName,list,null,enableTransaction);
    }
	public ProcExecuteNoResult(String procName,List<ISqlParameter> list){
    	super(procName,list,null,false);
    }
    public ProcExecuteNoResult(String procName){
    	super(procName,null,false);
    }
    public ProcExecuteNoResult(String procName,boolean enableTransaction){
    	super(procName,null,enableTransaction);
    }
	
	protected ResultSet getResultSet(CallableStatement cs) throws SQLException {
		cs.execute();
		return null;
	}

}
