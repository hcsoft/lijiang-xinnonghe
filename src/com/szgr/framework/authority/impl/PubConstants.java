package com.szgr.framework.authority.impl;

/**
 * <p>Title: ynds</p>
 * @version 1.1
 */

public interface PubConstants {
    public static final String VALID_STATUS = "01";
    public static final String INVALID_STATUS = "00";

    // 税务机关级别
    public static String TAXORGCLASS_PRO = "01"; //省级税务机关
    public static String TAXORGCLASS_SUP = "02"; //州市级税务机关
    public static String TAXORGCLASS_ORG = "03"; //县区级机关
    public static String TAXORGCLASS_DEPT = "04"; //分局所税务机关

    // 税务机关类别
    public static String TAXORGANIZATION = "01"; //暂：税务机关（区别于税务稽查）

    // 税务机关名称类型（长度）（taxname or shortname）
    //税务机关简称
    public static String TAXORGNAME_SHORT = "short"; //对应taxorgshortname
    //税务机关全称
    public static String TAXORGNAME_LONG = "long"; //对应taxorgname

    // 税务机关代码有效位长度
    public static int TAXORGLENGTH_SUP = 4;
    public static int TAXORGLENGTH_ORG = 6;
    public static int TAXORGLENGTH_DEPT = 8;

    //节点标识：node  “00”根节点 “01”叶子节点
    public static final String SYS_NODE_ROOT = "00";
    public static final String SYS_NODE_LEAF = "01";

//  //注册类型代码节点标识: "0"根节点  "1"叶子节点
//  public static final String ECONATURE_NODE_ROOT = "0";
//  public static final String ECONATURE_NODE_LEAF = "1";

    //税种税目代码节点标识: "99"税种  "00"税目
    public static final String TAXCODE_ROOT = "99";
    public static final String TAXCODE_LEAF = "00";
    //费种费目代码节点标识: "00"费种类  "01"费种代码  "02"费目代码
    public static final String FEETYPECODE_TYPE = "00";
    public static final String FEETYPECODE_FEE = "01";
    public static final String FEETYPECODE_FEEITEM = "02";
    //(费)单位类型代码节点标识: "00"  "01"
    public static final String FPROPERTYPECODE_FEEITEMTYPE = "00";
    public static final String FPROPERTYPECODE_TYPE = "01";


    //字符型空值：存储点(.)
    public static final String SYS_CHAR_NULL = ".";

    //数值型空值：存储0.00
    public static double SYS_DECIMAL_NULL = 0.00;


    //纳税人状态标识
    public static String TAXPAYERSTATUS_NOMAL = "01";

    //纳税人稽查状态
    public static String UNTAXPAYERSAUDIT_FLAG = "00";
    public static String TAXPAYERSAUDIT_FLAG = "01";
    //纳税人"自开货运发票"标识
    public static String TAXPAYER_FREIGHTSELFFLAG = "01";
    //纳税人"代开货运发票"标识
    public static String TAXPAYER_FREIGHTSUPPLYFLAG = "01";
    //停业完讫标志
    public static String STOP_FLAG = "00";
    public static String STOPEND_FLAG = "01";
    //复业完讫标志
    public static String RESTORE_FLAG = "00";
    public static String RESTOREEND_FLAG = "01";
    //注销完讫标志
    public static String CANCEL_FLAG = "00";
    public static String CANCELEND_FLAG = "01";

    //纳税人检查状态
    public static String UNTAXPAYERSCHECK_FLAG = "00";
    public static String TAXPAYERSCHECK_FLAG = "01";

    /*************add by liuwanfu begain**************/
    //税务人员类型
    //领导
    public static String TAXEMPCODE_AUTH_TYPE = "10";
    //征收人员
    public static String TAXEMPCODE_LEVY_TYPE = "20";
    //税收管理员
    public static String TAXEMPCODE_TAXMANAGER_TYPE = "30";


    //税务人员标识
    //领导标识
    public static String TAXEMPCODE_AUTH_FLAG = "01";
    //征收人员标识
    public static String TAXEMPCODE_LEVY_FLAG = "01";
    //专管员标识
    public static String TAXEMPCODE_TAXMANAGER_FLAG = "01";

    /*************add by liuwanfu end**************/

    /*
     * 以上是cache使用的常量 END
     */
    /**
     * 处罚信息表操作标识，登记与稽查共用
     */
    //登记标识为10
    public static String MGR_PUNISHINFO_OPERATEFLAG_TAXREG = "10";
    //稽查标识为20
    public static String MGR_PUNISHINFO_OPERATEFLAG_TAXAUDIT = "20";


    /**
     * 设立登记状态标识，系统级常量
     * by曾智
     */
    //设立登记状态（完成）
    public static String REG_TAXREGSTATUS_FINISHED = "01";
    //设立登记状态（未完成）
    public static String REG_TAXREGSTATUS_UNFINISHED = "00";

    /**
     *暂收款类型: 01--发票保证金  02--预缴税款保证金  03--拍卖款
     * add by wangbangcai
     */
    public static final String TMPAMOUNTCODE_INVPAY = "01";
    public static final String TMPAMOUNTCODE_PREPAY = "02";
    public static final String TMPAMOUNTCODE_SALEPAY = "03";
}
