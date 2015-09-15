package com.szgr.framework.authority.datarights;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import com.szgr.framework.util.StringUtil;
import com.szgr.framework.util.TypeChecker;


/**
 * 数据权限操作的帮助类
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
   * 将数据权限sql中的所有字段加上前缀
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
   * 将通配符的值替换为有效的数值
   *  必须先替换通配符
   * @param sql String
   * @param userright UserRights
   * @return String
   */

  public static String replaceWildCard(String sql, UserRights userright) {

    //替换市局机关通配符
    if (sql.indexOf(DataRightsConstants.USER_TAXORGSUPCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXORGSUPCODE,
                           "'" + userright.getTaxorgsupcode() + "'");
    }
    //替换县区通配符
    if (sql.indexOf(DataRightsConstants.USER_TAXORGCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXORGCODE,
                           "'" + userright.getTaxorgcode() + "'");
    }
    //替换分局所通配符
    if (sql.indexOf(DataRightsConstants.USER_TAXDEPTCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXDEPTCODE,
                           "'" + userright.getTaxdeptcode() + "'");
    }
    //替换税收管理员通配符
    if (sql.indexOf(DataRightsConstants.USER_TAXMANAGERCODE) >= 0) {
      sql = sql.replaceAll(DataRightsConstants.USER_TAXMANAGERCODE,
                           "'" + userright.getTaxmanagercode() + "'");
    }
    return sql;
  }

  /**
   * 替换
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
   * 检查最终的权限字符串中有没有#null#的字符串，如果有则提示用户权限配置不正确
   */
  public static void illegalCheck(String sql) throws  Exception {
    if (sql.indexOf(DataRightsConstants.NOVALUE) >= 0) {
      throw new  Exception("数据权限配置不正确，给用户配置的权限小于其实际权限！");
    }

    if (sql.indexOf("#") >= 0) {
      throw new  Exception("不能正确解析配置的数据权限！");
    }
  }

  /**
   * 初始化用户的userright对象
   */
  public static UserRights initialUserRights(String usertaxorgcode,
                                             String organizationlevel,
                                             String usercode, String orgtype) {
    UserRights userright = new UserRights();
    //省局
    if (DataRightsConstants.ORGANAZITIONLEVL01.equals(organizationlevel)) {
      userright.setUsertaxorgcode(usertaxorgcode);
      userright.setTaxmanagercode(usercode);

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL02.equals(organizationlevel)) {
      userright.setUsertaxorgcode(usertaxorgcode);
      /** @todo 市局的下设机构是否要截位 */
      String taxorgsupcode = usertaxorgcode.substring(0, 4) + "000000";
      userright.setTaxorgsupcode(taxorgsupcode);
      userright.setTaxmanagercode(usercode);

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL03.equals(organizationlevel)) {
      //县区局
      userright.setUsertaxorgcode(usertaxorgcode);
      String taxorgsupcode = usertaxorgcode.substring(0, 4) + "000000";
      userright.setTaxorgsupcode(taxorgsupcode);
      String taxorgcode = usertaxorgcode.substring(0, 6) + "0000";
      userright.setTaxorgcode(taxorgcode);
      userright.setTaxmanagercode(usercode);

      //分局所
    }
    else if (DataRightsConstants.ORGANAZITIONLEVL04.equals(organizationlevel)) {
      userright.setUsertaxorgcode(usertaxorgcode);
      String taxorgsupcode = usertaxorgcode.substring(0, 4) + "000000";
      userright.setTaxorgsupcode(taxorgsupcode);
      String taxorgcode = usertaxorgcode.substring(0, 6) + "0000";
      userright.setTaxorgcode(taxorgcode);
      userright.setTaxdeptcode(usertaxorgcode);
      //需要判断机关类型：只管不收 自管自收　只收不管
      //用户的登录机关为
      if (DataRightsConstants.LEVYORGTYPE.equals(orgtype) ||
          DataRightsConstants.LEVYMAGORGTYPE.equals(orgtype)) {
        userright.setTaxlevyorgcode(usertaxorgcode);
      }
      userright.setTaxmanagercode(usercode);

    }

    return userright;
  }

  /**
   * 在用户和其所在的部门都没有配置数据权限的情况下，输出其默认的征收和管理权限
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
      //县区局

      return "taxorgcode = '" + usertaxorgcode.substring(0, 6) + "0000'";

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL04.equals(organizationlevel)) {
      //分局所
      return "taxdeptcode = '" + usertaxorgcode + "'";
    }

    return "";

  }

  /**
   * 获取默认的下拉列表权限
   * @param usertaxorgcode String
   * @param organizationlevel String
   * @return String
   */
  public static String getDefaultSelectRights(String usertaxorgcode,
                                              String organizationlevel) {
    if (DataRightsConstants.ORGANAZITIONLEVL01.equals(organizationlevel)) {
      return "";
    }
    //市级权限
    else if (DataRightsConstants.ORGANAZITIONLEVL02.equals(organizationlevel)) {

      return "taxorgcode like '" + usertaxorgcode.substring(0, 4) + "%'";

    }

    else if (DataRightsConstants.ORGANAZITIONLEVL03.equals(organizationlevel)) {
      //县区局

      return "taxorgcode like '" + usertaxorgcode.substring(0, 6) + "%'";

    }
    else if (DataRightsConstants.ORGANAZITIONLEVL04.equals(organizationlevel)) {
      //分局所
      return "taxorgcode = '" + usertaxorgcode + "'";
    }

    return "";

  }
  /**
   * 
   * taxorgcode like '530124%'  返回530124
	 * taxorgcode = '5301240000' 返回5301240000
    * 解析下拉权限字符串方法
    * selectAuthstr为输入的要解析的下拉权限过滤sql
    * @param selectAuth String
    */
   public static String[] getParsedSelectAuth(String selectAuthstr) {

      ArrayList al = new ArrayList();
     //为空或者权限为所有则返回空字符串
     if (TypeChecker.isEmpty(selectAuthstr)) {
       return null;
     }


     //String likeequalstring = null;
     //如果有like字符则对其进行解析
     if (selectAuthstr.indexOf("like") >= 0) {
       String[] sastr = StringUtil.divideString(selectAuthstr, "'", "%'");

       for(int a =0;a<sastr.length;a++){
         al.add(sastr[a]);
       }
     //likeequalstring = sastr[0];
     }
     else if (selectAuthstr.indexOf("=") >= 0) {
       //如果有=号配置对相应的字符串进行处理
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

     //如果有in字符串，对这部分sql进行切片处理
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
         //设置in部分的枚举值
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
