package com.szgr.framework.authority.datarights;


/**
 * 用户登录后，可能的代码属性，如果没有的话值为#null#
 * <p>Title: kumming tax</p>
 * <p>Description: manager statics developing</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: thtf yunnan branch</p>
 * @author not attributable
 * @version 1.0
 */
public class UserRights {
  //用户表中，用户的所属主管地税机关
  private String usertaxorgcode;
  //用户的市一级地税机关
  private String taxorgsupcode;
  //用户的县区级地税机关
  private String taxorgcode;
  //用户的分局所地税机关
  private String taxdeptcode;
  //用户所在的征收机关代码
  private String taxlevyorgcode;
  //专管员代码
  private String taxmanagercode;
  //征收权限
  //private String levyrights;
  //管理权限
  //private String managerright;
  //征收下拉权限
 // private String levyselectright;
  //管理下拉权限
 // private String managerselectright;

  public UserRights() {
    setUsertaxorgcode(DataRightsConstants.NOVALUE);
    setTaxorgsupcode(DataRightsConstants.NOVALUE);
    setTaxorgcode(DataRightsConstants.NOVALUE);
    setTaxdeptcode(DataRightsConstants.NOVALUE);
    setTaxlevyorgcode(DataRightsConstants.NOVALUE);
    setTaxmanagercode(DataRightsConstants.NOVALUE);
  }
  public String getUsertaxorgcode() {
    return usertaxorgcode;
  }
  public void setUsertaxorgcode(String usertaxorgcode) {
    this.usertaxorgcode = usertaxorgcode;
  }
  public String getTaxorgsupcode() {
    return taxorgsupcode;
  }
  public void setTaxorgsupcode(String taxorgsupcode) {
    this.taxorgsupcode = taxorgsupcode;
  }
  public String getTaxorgcode() {
    return taxorgcode;
  }
  public void setTaxorgcode(String taxorgcode) {
    this.taxorgcode = taxorgcode;
  }
  public String getTaxdeptcode() {
    return taxdeptcode;
  }
  public void setTaxdeptcode(String taxdeptcode) {
    this.taxdeptcode = taxdeptcode;
  }
  public String getTaxlevyorgcode() {
    return taxlevyorgcode;
  }
  public void setTaxlevyorgcode(String taxlevyorgcode) {
    this.taxlevyorgcode = taxlevyorgcode;
  }
  public String getTaxmanagercode() {
    return taxmanagercode;
  }
  public void setTaxmanagercode(String taxmanagercode) {
    this.taxmanagercode = taxmanagercode;
  }


//  public String getLevyrights() {
//    return levyrights;
//  }
//  public void setLevyrights(String levyrights) {
//    this.levyrights = levyrights;
//  }
//  public String getManagerright() {
//    return managerright;
//  }
//  public void setManagerright(String managerright) {
//    this.managerright = managerright;
//  }
//  public String getLevyselectright() {
//    return levyselectright;
//  }
//  public void setLevyselectright(String levyselectright) {
//    this.levyselectright = levyselectright;
//  }
//  public String getManagerselectright() {
//    return managerselectright;
//  }
//  public void setManagerselectright(String managerselectright) {
//    this.managerselectright = managerselectright;
//  }


  public  String toString(){
     StringBuffer  stringBuffer = new StringBuffer();
     stringBuffer.append("usertaxorgcode:").append(this.getUsertaxorgcode())
         .append("\ntaxorgsupcode:").append(this.getTaxorgsupcode())
         .append("\ntaxorgcode:").append(this.getTaxorgcode())
         .append("\ntaxdeptcode").append(this.getTaxdeptcode())
         .append("\ntaxlevyorgcode:").append(this.getTaxlevyorgcode())
         .append("\ntaxmanagercode:").append(this.getTaxmanagercode());

      return stringBuffer.toString();
   }

}
