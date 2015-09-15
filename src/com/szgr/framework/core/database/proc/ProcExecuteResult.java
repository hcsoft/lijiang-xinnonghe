package com.szgr.framework.core.database.proc;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class ProcExecuteResult extends AbstractProcExecute{

	public ProcExecuteResult(String procName,List<ISqlParameter> list,Class cls,boolean enableTransaction){
    	super(procName,list,cls,enableTransaction);
    }
	public ProcExecuteResult(String procName,List<ISqlParameter> list,Class cls){
    	super(procName,list,cls,false);
    }
    public ProcExecuteResult(String procName,Class cls,boolean enableTransaction){
    	super(procName,cls,enableTransaction);
    }
    public ProcExecuteResult(String procName,Class cls){
    	super(procName,cls,false);
    }
    
	
	protected ResultSet getResultSet(CallableStatement cs) throws SQLException {
		return cs.executeQuery();
	}

}
