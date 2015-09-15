package com.szgr.framework.authority.datarights;

public class DataRightsConstants {
  private DataRightsConstants() {
  }
  //机构行政级别
  //省级
  public final static  String  ORGANAZITIONLEVL01= "01";
 //市级
  public final static  String ORGANAZITIONLEVL02 = "02";
  //县区局
  public final static  String ORGANAZITIONLEVL03 = "03";
  //分局所级数据权限
   public final static  String ORGANAZITIONLEVL04 = "04";

   //州市级地税机关
   public final static String TAXORGSUPCODE = "taxorgsupcode";
   //地税机关
   public final static String TAXORGCODE = "taxorgcode";
   //地税部门
   public final static String TAXDEPTCODE = "taxdeptcode";
   //征收机关
   public final static String TAXLEVYORGCODE ="taxlevyorgcode";
   //税收管理员
   public final static String TAXMANAGERCODE ="taxmanagercode";

   /**
    * 04级别分局所的机关类型分为征收机关，管理机关,征收管理机关三种
    */
   //征收机关
   public final static String LEVYORGTYPE  ="01";
   //管理机关
   public final static String MANAGERORGTYPE ="02";
   //征收管理机关
   public final static String LEVYMAGORGTYPE ="03";


   //配置下拉列表权限的几种可能的通配符
    //省级下拉列表权限
    public final static String RIGHTTYPE01 ="#allright#";
    //市级下拉列表权限
    public final static String RIGHTTYPE02 = "#taxorgsupright#";
    //县区级下拉列表权限
    public final static String RIGHTTYPE03 = "#taxorgright#";
    //分局所权限
    public final static String RIGHTTYPE04 = "#taxdeptright#";




   //省级数据权限配置
  //空串
  //市级数据权限
  //userrights对象中usertaxorgcode和taxorgsupcode有值
  //可能的配置为
  //1、空串
  //2、taxorgsupcode = {user.taxorgsupcode} or taxorgsupcode in ('5301','5012')
  //县区局数据权
  //userrights对象中usertaxorgcode、taxorgsupcode、taxorgcode有值
  //1、空串
  //2、taxorgsupcode = {user.taxorgsupcode} or taxorgsupcode in('5301','5012')
  //3、taxorgcode = {user.taxorgcode} or taxorgcode in ('5301124','53012264')
  //分局所权限
  //userrights对象中usertaxorgcode、taxorgsupcode、taxorgcode、taxdeptcode有值
  //1、空串
  //2、taxorgsupcode = {user.taxorgsupcode} or taxorgsupcode in('5301','5012')
  //3、taxorgcode = {user.taxorgcode} or taxorgcode in ('5301124','53012264')
  //4、taxdeptcode = {user.taxdeptcode} or taxdeptcode in ('2333','22222')
  //征收权限5、taxlevyorgcode ={user.taxdeptcode} or
  /**
   * 标识属性为空的常量字符
   */
  public static final String NOVALUE ="#null#";

  /**
   * 可能的数据权限配置通配符
   */
  /** @todo 用户的taxorgcode 根据以下关键字定 */
  //市级机关
  public final static String USER_TAXORGSUPCODE ="#user.taxorgsupcode#";
  //县区级机关
  public final static String USER_TAXORGCODE ="#user.taxorgcode#";
  //分局所
  public final static String USER_TAXDEPTCODE ="#user.taxdeptcode#";
  //税收管理员
  public final static String USER_TAXMANAGERCODE ="#user.taxmanagercode#";

  //征收机关权限是配置的，通用程序不进行处理，只提供进行征收权限访问的方法
  //不允许出现{user.taxlevyorgcode}
}
