package com.szgr.framework.core.database.proc;

import java.util.List;

/**
 * 
* <p>Title: ProcResult.java</p>
* <p>Description:����洢����ִ�з��ص����� </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: szgr</p>
* @author xuhong
* @date 2013-11-4
* @version 1.0
 */
public class ProcResult {
	/**
	 * ����еĻ���Ϊ�洢����ִ�з��صĽ����
	 */
    private List<Object> result;
    /**
     * �洢����ִ�з��ص�out�Ĳ���ֵ
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
			sb.append("û���κν����");
		}
		if(outResult != null){
			for(int i = 0;i < outResult.length;i++){
				sb.append("��"+(i+1)+"��out������ֵΪ��"+outResult[i]);
			}
		}else{
			sb.append("û��out������ֵ");
		}
		return sb.toString();
	}
}
