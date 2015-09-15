package com.szgr.framework.core.database.proc;

import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.szgr.framework.pagination.PageUtil;

/**
 * 分页的存储过程
* <p>Title: CallProcPage.java</p>
* <p>Description: </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-11-4
* @version 1.0
 */
public class CallProcPage {
	private Object[] values;
	private IProcExecute procExecute;
	private boolean page;
	/**
	 * 
	 * @param procName 存储过程名字
	 * @param values  存储过程的参数
	 * @param cls   返回的结果集封装的对象
	 * @param page  是否存在分页
	 */
    public CallProcPage(String procName,Object[] values,Class cls,boolean page){
    	this(procName,values,cls,page,false);
    }
    /**
     * 
     * @param procName   存储过程名字
     * @param values  存储过程的参数
     * @param cls  返回的结果集封装的对象
     * @param page  是否存在分页
     * @param enableTransaction  是否支持事务
     * 且存储过程的实现中，
     * 1、创建临时表时，需要创建在存储过程之前，因此也不能使用select into语句创建表
     * 2、不能在结尾删除临时表
     * 请看@see TaxNoticeService.getNeedTaxNotice
     */
    public CallProcPage(String procName,Object[] values,Class cls,boolean page,boolean enableTransaction){
    	this.values = values;
    	this.page = page;
    	AbstractProcExecute p = new ProcExecuteResult(procName,cls);
    	ISqlParameter[] parameterAry = getSqlParameterAry();
    	p.setParameters(parameterAry);
    	p.enableTransactionCapable(enableTransaction);
    	this.procExecute = p;
    }
    private ISqlParameter[] getSqlParameterAry(){
    	List<ISqlParameter> parameterList = new ArrayList<ISqlParameter>();
    	if(values != null){
    		for(int i = 0; i < values.length;i++){
    			parameterList.add(new SqlInParameter(values[i]));
    		}
    	}
    	if(this.page)
    	   parameterList.add(new SqlOutParameter(Types.INTEGER));
    	ISqlParameter[] result = new ISqlParameter[parameterList.size()];
    	parameterList.toArray(result);
    	return result;
    }
    /**
     * 如果page等于true，则返回JSONObject
     * 如果page等于false，则是正常返回List<class参数>
     * @return
     */
    public Object execute(){
    	ProcResult temp = this.procExecute.execute();
    	if(this.page){
    		JSONObject j = new JSONObject();
    		j.put(PageUtil.PAGE_TOTAL,temp.getOutResult()[0]);
    		JSONArray jsonArray = new JSONArray();
    		jsonArray.addAll(temp.getResult());
    		j.put(PageUtil.PAGE_ROW,jsonArray);
    		return j;
    	}else{
    		return temp.getResult();
    	}
    }
	public void setProcExecute(IProcExecute procExecute) {
		this.procExecute = procExecute;
	}
}
