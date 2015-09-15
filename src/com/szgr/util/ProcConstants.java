package com.szgr.util;
public interface ProcConstants {
	/**
	 * 根据年份、税种、税目汇总应纳税信息的存储过程
	 */
	String SP_VIEWTOTALBYYEARTAXTYPE = "SP_VIEWTOTALBYYEARTAXTYPE";
	/**
	 * 根据年份、纳税人汇总的存储过程
	 */
	String SP_VIEWTOTALBYYEARTAXPAYER = "SP_VIEWTOTALBYYEARTAXPAYER";
	/**
	 * 根据相关条件获取应纳税明细的存储过程
	 */
	String SP_ANALIZYVIEWTOTAL = "SP_ANALIZYVIEWTOTAL";
	/**
	 * 根据相关条件获取纳税人信息的存储过程
	 */
	String SP_TAXPAYERSTATICS = "SP_TAXPAYERSTATICS";
	/**
	 * 根据相关条件查询欠税的企业及欠税情况,税务事项通知书的存储过程
	 */
	String SP_TAXNOTICE = "SP_TAXNOTICE";
	/**
	 * 根据相关条件查询需要打限缴通知书的存储过程
	 */
	String SP_PAYNOTICE = "SP_PAYNOTICE";
	/**
	 * 应纳税统计的存储过程
	 */
	String SP_SHOULDTAXTOTAL = "SP_SHOULDTAXTOTAL";
	/**
	 * 应纳税统计明细的存储过程
	 */
	String SP_SHOULDTAXTOTALDETAIL = "SP_SHOULDTAXTOTALDETAIL";
	
	/**
	 * 欠税的存储过程
	 */
	String SP_OWETAXINFO = "SP_OWETAXINFO";
	/**
	 * 欠税明细的存储过程
	 */
	String SP_OWETAXSUBINFO = "SP_OWETAXSUBINFO";
	/**
	 * 清册的存储过程
	 */
	String SP_SHOULDTAXDETAIL = "SP_SHOULDTAXDETAIL";
	
	/**
	 * 获取临时计算机编码
	 */
	String SP_TEMPTAXPAYER = "P_CREATETEMPORARYTAXPAYERID";
	
	/**
	 * 根据房产、纳税人、土地获取应纳税信息
	 */
	String SP_SHOULDTAX = "SP_TAXBYLANDORTAXPAYER";
	/**
	 * 根据土地、房产获取历史交易记录
	 */
	String SP_HISTORY = "SP_HISTORY";
	/**
	 * 根据条件查询土地的应纳税情况
	 */
	String SP_MAPLANDINFO = "SP_MAPLANDINFO";
	/**
	 * 根据条件查询某个行政区划的土地的应纳税情况
	 */
	String SP_TAXBYCONDITION = "SP_TAXBYCONDITION";
	
	String SP_MAPTAXPAYERINFO = "SP_MAPTAXPAYERINFO";
	/**
	 * 查询土地及相关应纳税
	 */
	String SP_LANDINFO = "SP_LANDINFO";
	/**
	 * 查询纳税人及相关应纳税
	 */
	String SP_TAXPAYERINFO = "SP_TAXPAYERINFO";
	
	/**
	 * 新的数据整理存储过程
	 */
	String SP_NEWDATAARRANGE = "SP_NEWDATAARRANGE";
	/**
	 * 根据土地的所属村委会获取父级、子级的行政区名称
	 */
	String SP_GETDISTRICT = "SP_GETDISTRICT";
	
}
