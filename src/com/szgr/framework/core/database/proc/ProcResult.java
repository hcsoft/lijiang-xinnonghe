package com.szgr.framework.core.database.proc;

import java.util.List;

/**
 * 
* <p>Title: ProcResult.java</p>
* <p>Description:代表存储过程执行返回的数据 </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-11-4
* @version 1.0
 */
public class ProcResult {
	/**
	 * 如果有的话，为存储过程执行返回的结果集
	 */
    private List<Object> result;
    /**
     * 存储过程执行返回的out的参数值
     */
    private Object[] outResult;
	public List<Object> getResult() {
		return result;
	}
	public void setResult(List<Object> result) {
		this.result = result;
	}
	public Object[] getOutResult() {
		return outResult;
	}
	public void setOutResult(Object[] outResult) {
		this.outResult = outResult;
	}
	
	public String toString(){
		StringBuffer sb = new StringBuffer();
		if(result != null){
			for(Object obj : result){
				sb.append(obj+"\r\n");
			}
		}else{
			sb.append("没有任何结果集");
		}
		if(outResult != null){
			for(int i = 0;i < outResult.length;i++){
				sb.append("第"+(i+1)+"个out参数的值为："+outResult[i]);
			}
		}else{
			sb.append("没有out参数的值");
		}
		return sb.toString();
	}
}
