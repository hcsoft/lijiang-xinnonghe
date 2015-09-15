package com.szgr.framework.core.database.proc;

import java.util.List;

public class ProcSingleValue extends CallProcPage {
       /**
        * ÎÞout²ÎÊý
        * @param procName
        * @param values
        */
	  public ProcSingleValue(String procName,Object[] values,boolean enableTransaction){
		  super(procName,values,null,false,enableTransaction);
	  }
	  public Object getSingleValue(){
		  List<Object> result = (List<Object>)super.execute();
		  return result != null && result.size() > 0 ? result.get(0):null;
	  }
}
