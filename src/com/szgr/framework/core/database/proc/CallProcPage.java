package com.szgr.framework.core.database.proc;

import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.szgr.framework.pagination.PageUtil;

/**
 * ��ҳ�Ĵ洢����
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
	 * @param procName �洢��������
	 * @param values  �洢���̵Ĳ���
	 * @param cls   ���صĽ������װ�Ķ���
	 * @param page  �Ƿ���ڷ�ҳ
	 */
    public CallProcPage(String procName,Object[] values,Class cls,boolean page){
    	this(procName,values,cls,page,false);
    }
    /**
     * 
     * @param procName   �洢��������
     * @param values  �洢���̵Ĳ���
     * @param cls  ���صĽ������װ�Ķ���
     * @param page  �Ƿ���ڷ�ҳ
     * @param enableTransaction  �Ƿ�֧������
     * �Ҵ洢���̵�ʵ���У�
     * 1��������ʱ��ʱ����Ҫ�����ڴ洢����֮ǰ�����Ҳ����ʹ��select into��䴴����
     * 2�������ڽ�βɾ����ʱ��
     * �뿴@see TaxNoticeService.getNeedTaxNotice
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
     * ���page����true���򷵻�JSONObject
     * ���page����false��������������List<class����>
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
