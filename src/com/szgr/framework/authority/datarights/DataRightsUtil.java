package com.szgr.framework.authority.datarights;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import com.szgr.framework.util.StringUtil;
import com.szgr.framework.util.TypeChecker;


/**
 * ����Ȩ�޲����İ�����
 * <p>Title: kumming tax</p>
 * <p>Description: manager statics developing</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: thtf yunnan branch</p>
 * @author not attributable
 * @version 1.0
 */
public class DataRightsUtil {
  private final static Logger logger = Logger.getLogger(DataRightsUtil.class);
  public DataRightsUtil() {
  }

  /**
   * ������Ȩ��sql�е������ֶμ���ǰ׺
   * @param sql String
   * @param prefix String
   * @return String
   */
  public static String addPrefixs(String sql, String prefix) {

    String[] columnnames = new String[5];
    columnnames[0] = DataRightsConstants.TAXORGSUPCODE;
    columnnames[1] = DataRightsConstants.TAXORGCODE;
    columnnames[2] = DataRightsConstants.TAXDEPTCODE;
    columnnames[3] = DataRightsConstants.TAXLEVYORGCODE;
    columnnames[4] = DataRightsConstants.TAXMANAGERCODE;
    if (!(prefix.indexOf(".")+1 == prefix.length())) {
       prefix = prefix + ".";
    }
    for (int a = 0; a < columnnames.length; a++) {
      if (sql.indexOf(columnnames[a]) >= 0) {
        sql = sql.replaceAll(columnnames[a], prefix + columnnames[a]);
      }
    }
    return sql;
  }

  /**
   * ��ͨ�����ֵ�滻Ϊ��Ч����ֵ
   *  �������滻ͨ���
   * @param sql String
   * @param userright UserRights
   * @return String
   */

  public static String replaceWildCard(String sql, UserRights userright) {

    //�滻�оֻ���ͨ���
    if (sql.indexOf(DataRightsConstants.USER_TAXORGSUPCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXORGSUPCODE,
                           "'" + userright.getTaxorgsupcode() + "'");
    }
    //�滻����ͨ���
    if (sql.indexOf(DataRightsConstants.USER_TAXORGCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXORGCODE,
                           "'" + userright.getTaxorgcode() + "'");
    }
    //�滻�־���ͨ���
    if (sql.indexOf(DataRightsConstants.USER_TAXDEPTCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXDEPTCODE,
                           "'" + userright.getTaxdeptcode() + "'");
    }
    //�滻˰�չ���Աͨ���
    if (sql.indexOf(DataRightsConstants.USER_TAXMANAGERCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXMANAGERCODE,
                           "'" + userright.getTaxmanagercode() + "'");
    }
    return sql;
  }

  /**
   * �滻
   * @param selectrightsql String
   * @param usertaxorgcode String
   * @return String
   */
  public static String replaceSelectWildCard(String selectrightsql,
                                             String usertaxorgcode) {

    if (selectrightsql.indexOf(DataRightsConstants.RIGHTTYPE01) >= 0) {
      return "";
    }
    if (selectrightsql.indexOf(DataRightsConstants.RIGHTTYPE02) >= 0) {

      String taxorgsupright = " taxorgcode like '" +
          usertaxorgcode.substring(0, 4) + "%'";

      selectrightsql = selectrightsql.replaceAll(DataRightsConstants.
                                                 RIGHTTYPE02, taxorgsupright);
    }

    if (selectrightsql.indexOf(DataRightsConstants.RIGHTTYPE03) >= 0) {

      String taxorgright = " taxorgcode like '" + usertaxorgcode.substring(0, 6) +
          "%'";

      selectrightsql = selectrightsql.replaceAll(DataRightsConstants.
                                                 RIGHTTYPE03, taxorgright);
    }
    if (selectrightsql.indexOf(DataRightsConstants.RIGHTTYPE04) >= 0) {

      String taxdeptright = " taxorgcode = '" + usertaxorgcode + "'";

      selectrightsql = selectrightsql.replaceAll(DataRightsConstants.
                                                 RIGHTTYPE04, taxdeptright);
    }

    return selectrightsql;
  }

  /**
   * ������յ�Ȩ���ַ�������û��#null#���ַ��������������ʾ�û�Ȩ�����ò���ȷ
   */
  public static void illegalCheck(String sql) throws  Exception {
    if (sql.indexOf(DataRightsConstants.NOVALUE) >= 0) {
      throw new  Exception("����Ȩ�����ò���ȷ�����û����õ�Ȩ��С����ʵ��Ȩ�ޣ�");
    }

    if (sql.indexOf("#") >= 0) {
      throw new  Exception("������ȷ�������õ�����Ȩ�ޣ�");
    }
  }

  /**
   * ��ʼ���û���userright����
   */
  public static UserRights initialUserRights(String usertaxorgcode,
                                             String organizationlevel,
                                             String usercode, String orgtype) {
    UserRights userright = new UserRights();
    //ʡ��
    if (DataRightsConstants.ORGANAZITIONLEVL01.equals(organizationlevel)) {
      userright.setUsertaxorgcode(usertaxorgcode);
      userright.setTaxmanagercode(usercode);

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL02.equals(organizationlevel)) {
      userright.setUsertaxorgcode(usertaxorgcode);
      /** @todo �оֵ���������Ƿ�Ҫ��λ */
      String taxorgsupcode = usertaxorgcode.substring(0, 4) + "000000";
      userright.setTaxorgsupcode(taxorgsupcode);
      userright.setTaxmanagercode(usercode);

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL03.equals(organizationlevel)) {
      //������
      userright.setUsertaxorgcode(usertaxorgcode);
      String taxorgsupcode = usertaxorgcode.substring(0, 4) + "000000";
      userright.setTaxorgsupcode(taxorgsupcode);
      String taxorgcode = usertaxorgcode.substring(0, 6) + "0000";
      userright.setTaxorgcode(taxorgcode);
      userright.setTaxmanagercode(usercode);

      //�־���
    }
    else if (DataRightsConstants.ORGANAZITIONLEVL04.equals(organizationlevel)) {
      userright.setUsertaxorgcode(usertaxorgcode);
      String taxorgsupcode = usertaxorgcode.substring(0, 4) + "000000";
      userright.setTaxorgsupcode(taxorgsupcode);
      String taxorgcode = usertaxorgcode.substring(0, 6) + "0000";
      userright.setTaxorgcode(taxorgcode);
      userright.setTaxdeptcode(usertaxorgcode);
      //��Ҫ�жϻ������ͣ�ֻ�ܲ��� �Թ����ա�ֻ�ղ���
      //�û��ĵ�¼����Ϊ
      if (DataRightsConstants.LEVYORGTYPE.equals(orgtype) ||
          DataRightsConstants.LEVYMAGORGTYPE.equals(orgtype)) {
        userright.setTaxlevyorgcode(usertaxorgcode);
      }
      userright.setTaxmanagercode(usercode);

    }

    return userright;
  }

  /**
   * ���û��������ڵĲ��Ŷ�û����������Ȩ�޵�����£������Ĭ�ϵ����պ͹���Ȩ��
   * @param usertaxorgcode String
   * @param organizationlevel String
   * @return String
   */
  public static String getDefaultRights(String usertaxorgcode,
                                        String organizationlevel) {

    if (DataRightsConstants.ORGANAZITIONLEVL01.equals(organizationlevel)) {

      return "";

    }

    else if (DataRightsConstants.ORGANAZITIONLEVL02.equals(organizationlevel)) {

      return "taxorgsupcode = '" + usertaxorgcode.substring(0, 4) + "000000'";

    }

    else if (DataRightsConstants.ORGANAZITIONLEVL03.equals(organizationlevel)) {
      //������

      return "taxorgcode = '" + usertaxorgcode.substring(0, 6) + "0000'";

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL04.equals(organizationlevel)) {
      //�־���
      return "taxdeptcode = '" + usertaxorgcode + "'";
    }

    return "";

  }

  /**
   * ��ȡĬ�ϵ������б�Ȩ��
   * @param usertaxorgcode String
   * @param organizationlevel String
   * @return String
   */
  public static String getDefaultSelectRights(String usertaxorgcode,
                                              String organizationlevel) {
    if (DataRightsConstants.ORGANAZITIONLEVL01.equals(organizationlevel)) {
      return "";
    }
    //�м�Ȩ��
    else if (DataRightsConstants.ORGANAZITIONLEVL02.equals(organizationlevel)) {

      return "taxorgcode like '" + usertaxorgcode.substring(0, 4) + "%'";

    }

    else if (DataRightsConstants.ORGANAZITIONLEVL03.equals(organizationlevel)) {
      //������

      return "taxorgcode like '" + usertaxorgcode.substring(0, 6) + "%'";

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL04.equals(organizationlevel)) {
      //�־���
      return "taxorgcode = '" + usertaxorgcode + "'";
    }

    return "";

  }
  /**
   * 
   * taxorgcode like '530124%'  ����530124
	 * taxorgcode = '5301240000' ����5301240000
    * ��������Ȩ���ַ�������
    * selectAuthstrΪ�����Ҫ����������Ȩ�޹���sql
    * @param selectAuth String
    */
   public static String[] getParsedSelectAuth(String selectAuthstr) {

      ArrayList al = new ArrayList();
     //Ϊ�ջ���Ȩ��Ϊ�����򷵻ؿ��ַ���
     if (TypeChecker.isEmpty(selectAuthstr)) {
       return null;
     }


     //String likeequalstring = null;
     //�����like�ַ��������н���
     if (selectAuthstr.indexOf("like") >= 0) {
       String[] sastr = StringUtil.divideString(selectAuthstr, "'", "%'");

       for(int a =0;a<sastr.length;a++){
         al.add(sastr[a]);
       }
     //likeequalstring = sastr[0];
     }
     else if (selectAuthstr.indexOf("=") >= 0) {
       //�����=�����ö���Ӧ���ַ������д���
       int startindex = selectAuthstr.indexOf("=");
       String subs = selectAuthstr.substring(startindex,selectAuthstr.length());
       int start = subs.indexOf("'");
       subs = subs.substring(start+1,subs.length());
       start = subs.indexOf("'");
       subs = subs.substring(0,start);
       if(!TypeChecker.isEmpty(subs)){
          al.add(subs);
       }


//       String[] equalstr = StringUtil.divideString(subs, "'");
//       for(int i=0;i<equalstr.length;i++){
//         if(equalstr[i].length()==10){
//            al.add(equalstr[i]);
//         }
//       }

     }

     //�����in�ַ��������ⲿ��sql������Ƭ����
     int estartindex = selectAuthstr.indexOf("in");
     if (estartindex >= 0) {
       String insubs = selectAuthstr.substring(estartindex);
       String[] strbetw = StringUtil.divideString(insubs, "(", ")");
       String[] taxorgcodes = StringUtil.divideString( strbetw[0].toString(),"'");
       if(taxorgcodes.length>0){

         for(int a=0;a<taxorgcodes.length;a++){
           if(taxorgcodes[a].length()>6){
             al.add(taxorgcodes[a]);
           }
         }
         //����in���ֵ�ö��ֵ
       }
     }
     String rs[] = new String[al.size()];
     for(int a =0 ;a<al.size();a++){
       rs[a]= (String)al.get(a);
     }

     return  rs;

   }


  public static void main(String agrs[]) {
    logger.error("cccccccccccccccccccc");
    String sql =
        "taxdeptcode = #user.taxdeptcode# or taxdeptcode in ('2333','22222')";
    //System.out.println(addPrefixs(sql,"cccc"));

    //  UserRights userright = new UserRights();
    // userright.setTaxdeptcode("ddfd");
    //System.out.println(replaceWildCard(sql,userright));
    // System.out.println(sql.replaceAll("#user.taxdeptcode#","111"));
    // System.out.print("5301221".substring(0, 4) + "000000");

    String RIGHTTYPE02 =
        " terterter #user.taxorgcode.substring(0,4)+%#  rewrwerwrwe";
    //System.out.print(RIGHTTYPE02.replaceAll("taxorgcode.substring(0,4)","fdsfs"));

    // System.out.println(replaceSelectWildCard("taxdeptright", "53011200000"));
    String cc= "dfdfdf.ds.";
    System.out.println(cc.lastIndexOf(".")+":"+cc.length());

  }


}
