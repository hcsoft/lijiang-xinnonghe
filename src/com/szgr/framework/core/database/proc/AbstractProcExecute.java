package com.szgr.framework.core.database.proc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.util.Assert;

import com.szgr.framework.core.ApplicationContextUtils;
import com.szgr.framework.core.DefaultRowMapper;

/**
 * 
* <p>Title: AbstractProcExecute.java</p>
* <p>Description: </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-11-5
* @version 1.0
 */
public abstract class AbstractProcExecute implements IProcExecute {

	private static final Logger log = Logger.getLogger(AbstractProcExecute.class);
    private String procName;
    private ISqlParameter[] parameters;
    private Class cls;
    private boolean enableTransaction;
    /**
     * 
     * @param procName
     * @param list
     * @param cls
     * @param enableTransaction �Ƿ�֧������,�Ҵ洢���̵�ʵ���У�
     * 1��������ʱ��ʱ����Ҫ�����ڴ洢����֮ǰ�����Ҳ����ʹ��select into��䴴����
     * 2�������ڽ�βɾ����ʱ��
     */
    public AbstractProcExecute(String procName,List<ISqlParameter> list,Class cls,boolean enableTransaction){
    	ISqlParameter[] parameters = null;
    	if(list != null){
    		parameters = new ISqlParameter[list.size()];
    		parameters = list.toArray(parameters);
    	}
    	this.procName = procName;
    	this.parameters = parameters;
    	this.cls = cls;
    	this.enableTransaction = enableTransaction;
    	assertParameter();
    }
    public AbstractProcExecute(String procName,List<ISqlParameter> list,Class cls){
    	this(procName, list,cls,false);
    }
    public AbstractProcExecute(String procName,Class cls,boolean enableTransaction){
    	this(procName,null, cls,enableTransaction);
    }
    public AbstractProcExecute(String procName,Class cls){
    	this(procName,null, cls,false);
    }
    
    protected abstract ResultSet getResultSet(CallableStatement cs) throws SQLException;
    
    public ProcResult execute(){
       if(enableTransaction){
          enableProcTransaction();
       }
       long begin = System.currentTimeMillis();
       log.info("��ʼִ�д洢���̡�"+this.procName+"��,"+getParameterInfo()+"��");
       JdbcTemplate jt = ApplicationContextUtils.getJdbcTemplate();
       ProcResult result = jt.execute(new CallableStatementCreator() {
			
			public CallableStatement createCallableStatement(Connection con)
					throws SQLException{
				String executeProcStr = getProcExecuteStr();
				CallableStatement stm =  con.prepareCall(executeProcStr);
				if(parameters != null && parameters.length > 0){
					for(int i = 0;i < parameters.length;i++){
						if(parameters[i].getParameterType().equals(SqlParameterType.IN)){
							SqlInParameter inParameter = (SqlInParameter)parameters[i];
							stm.setObject(i+1,inParameter.getParameterValue());
						}else if(parameters[i].getParameterType().equals(SqlParameterType.OUT)){
							SqlOutParameter outParameter = (SqlOutParameter)parameters[i];
							stm.registerOutParameter(i+1,outParameter.getSqlType());
						}
					}
				}
				return stm;
			}
		},new CallableStatementCallback<ProcResult>() {
			
			public ProcResult doInCallableStatement(CallableStatement cs)
					throws SQLException, DataAccessException {
				ProcResult result =new ProcResult();
				ResultSet rs = getResultSet(cs);
				if(rs != null && cls == null){
					List<Object> tempList = new ArrayList<Object>();
					while(rs.next()){
						tempList.add(rs.getObject(1));
					}
					result.setResult(tempList);
					//throw new ApplicationException("ִ�д洢����ʱ�������Ϊ�գ����ǽ��յ�classΪ�գ�");
				}
				if(rs != null && cls != null){
					RowMapper rowMapper = new DefaultRowMapper(cls);
					List tempList = new ArrayList();
					int row = 0;
					while(rs.next()){
						row++;
						Object bo =  rowMapper.mapRow(rs, row);
						tempList.add(bo);
					}
					result.setResult(tempList);
				}
				List objectList = new ArrayList();
				if(parameters != null && parameters.length > 0){
					for(int i = 0;i < parameters.length;i++){
						if(parameters[i].getParameterType().equals(SqlParameterType.OUT)){
							Object value = cs.getObject((i+1));
							objectList.add(value);
						}
					}
				}
				Object[] outResult = new Object[objectList.size()];
				objectList.toArray(outResult);
				result.setOutResult(outResult);
				if(rs != null)
				  rs.close();
				return result;
			}
		});
       
       long end = System.currentTimeMillis();
       log.info("ִ�д洢���̡�"+this.procName+"�����ܹ�����ʱ��Ϊ��"+(end-begin)+"���룡");
       return result;	
    }
    /**
     * ʹ��ǰ�洢�����ܹ�������spring�����������
     */
    protected void enableProcTransaction(){
    	
    	
    	 ApplicationContextUtils.getJdbcTemplate().execute(new CallableStatementCreator() {
			
			public CallableStatement createCallableStatement(Connection con)
					throws SQLException {
				String executeProcStr = "{call sp_procxmode(?,?)}";
				CallableStatement stm =  con.prepareCall(executeProcStr);
				stm.setString(1,procName);
				stm.setString(2,"anymode");
				return stm;
			}
		},new CallableStatementCallback<Object>() {
			
			public Object doInCallableStatement(CallableStatement cs)
			throws SQLException, DataAccessException{
				cs.execute();
				return null;
			}
		});
    }
    private String getProcExecuteStr(){
    	StringBuffer sb = new StringBuffer();
    	sb.append("{call ");
    	sb.append(this.procName+"(");
    	if(this.parameters != null && this.parameters.length > 0){
    	    sb.append("?");
    		for(int i = 1;i < this.parameters.length;i++){
    			sb.append(",?");
    		}
    	}
    	sb.append(")}");
    	return sb.toString();
    }
    private void assertParameter(){
    	Assert.notNull(this.procName,"�洢�������ֲ���Ϊ�գ�");
    }
    private String getParameterInfo(){
    	StringBuffer sb = new StringBuffer();
    	if(parameters == null || parameters.length == 0){
    		sb.append("û�в���!");
    	}else{
    		for(int i = 0 ;i < parameters.length;i++){
    			sb.append("��"+(i+1)+"��������"+parameters[i]+"\r\n");
    		}
    	}
    	return sb.toString();
    }
	public void setParameters(ISqlParameter[] parameters) {
		this.parameters = parameters;
	}
	public void enableTransactionCapable(boolean enableTran){
		this.enableTransaction = enableTran;
	}
}
