package com.szgr.framework.authority.datarights;


/**
 * �û���¼�󣬿��ܵĴ������ԣ����û�еĻ�ֵΪ#null#
 * <p>Title: kumming tax</p>
 * <p>Description: manager statics developing</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: thtf yunnan branch</p>
 * @author not attributable
 * @version 1.0
 */
public class UserRights {
  //�û����У��û����������ܵ�˰����
  private String usertaxorgcode;
  //�û�����һ����˰����
  private String taxorgsupcode;
  //�û�����������˰����
  private String taxorgcode;
  //�û��ķ־�����˰����
  private String taxdeptcode;
  //�û����ڵ����ջ��ش���
  private String taxlevyorgcode;
  //ר��Ա����
  private String taxmanagercode;
  //����Ȩ��
  //private String levyrights;
  //����Ȩ��
  //private String managerright;
  //��������Ȩ��
 // private String levyselectright;
  //��������Ȩ��
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
