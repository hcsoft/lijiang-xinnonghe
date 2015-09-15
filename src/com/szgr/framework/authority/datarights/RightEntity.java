package com.szgr.framework.authority.datarights;

import java.io.Serializable;

/**
 * 存放一种权限信息的实体对象
 * <p>Title: kumming tax</p>
 * <p>Description: manager statics developing</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: thtf yunnan branch</p>
 * @author liuwanfu
 * @version 1.0
 */

public class RightEntity implements Serializable{
  //常量标签名
  private String label;
  //权限ｓｑｌ字符串
  private String sqlstring;
  //权限类型
  private String righttype;
  //
  public RightEntity() {
  }
  public String getLabel() {
    return label;
  }
  public void setLabel(String label) {
    this.label = label;
  }
  public String getSqlstring() {
    return sqlstring;
  }
  public void setSqlstring(String sqlstring) {
    this.sqlstring = sqlstring;
  }
  public String getRighttype() {
    return righttype;
  }
  public void setRighttype(String righttype) {
    this.righttype = righttype;
  }
  
  public String toString(){
	  StringBuffer sb = new StringBuffer();
	  sb.append("righttype="+this.getRighttype()+",label="+this.getLabel()+",sqlstring="+this.getSqlstring());
	  return sb.toString();
  }
}
