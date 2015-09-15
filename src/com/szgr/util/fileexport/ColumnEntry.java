package com.szgr.util.fileexport;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;

/**
 * 导出列对象实体
 * @author 熊杰
 * @version 1.0
 */
public class ColumnEntry {

  //列中文名
  private String englishName;

  //中文名
  private String chineseName = "无列名";

  //代码表名称，获者枚举值字符串

  private String codeEnuStr;

  //单元格式对象
  private HSSFCellStyle cellStyle =null;

  //数据类型
  private int datatype = 1;
  ;

  public ColumnEntry() {
  }
  /**
   * 构造函数
   * @param chineseName String 中文名
   * @param englishName String 英文名
   */
  public ColumnEntry(String chineseName, String englishName) {
    this.chineseName = chineseName;
    this.englishName = englishName;
  }
  /**
   * 构造函数，目前不使用
   * @param chineseName String中文名
   * @param englishName String 英文名
   * @param datatype int 数据类型
   * @param codeorEnuStr String 代码表集合名称或者枚举字符串
   * @return ColumnEntry

   */
  public ColumnEntry(String chineseName, String englishName, int datatype,
                     String codeorEnuStr) {
    this.chineseName = chineseName;
    this.englishName = englishName;
    this.datatype = datatype;
    this.codeEnuStr = codeorEnuStr;
  }

  /**
   * 获取简单字默认列对象
   * @return ColumnEntry
   */
  public static ColumnEntry getColumnEntryInstance() {

    return new ColumnEntry();
  }

  /**
   * 获取简单字默认列对象
   * @param chineseName String
   * @param englishName String
   * @return ColumnEntry
   */
  public static ColumnEntry getColumnEntryInstance(String chineseName,
      String englishName) {

    return new ColumnEntry(chineseName, englishName);
  }
  /**
   * 获取ColumnEntry事理,目前不使用
   * @param chineseName String中文名
   * @param englishName String 英文名
   * @param datatype int 数据类型
   * @param codeorEnuStr String 代码表集合名称或者枚举字符串
   * @return ColumnEntry
   */
  public static ColumnEntry getColumnEntryInstance(String chineseName,
      String englishName, int datatype, String codeorEnuStr) {
    return new ColumnEntry(chineseName, englishName, datatype, codeorEnuStr);
  }

  public String getChineseName() {
    return chineseName;
  }

  public int getDatatype() {
    return datatype;
  }

  public String getEnglishName() {
    return englishName;
  }

  public void setEnglishName(String englishName) {
    this.englishName = englishName;
  }

  public void setDatatype(int datatype) {
    this.datatype = datatype;
  }

  public void setChineseName(String chineseName) {
    this.chineseName = chineseName;
  }

  public HSSFCellStyle getCellStyle() {
    return cellStyle;
  }

  public void setCellStyle(HSSFCellStyle cellStyle) {
    this.cellStyle = cellStyle;
  }

  public String getCodeEnuStr() {
    return codeEnuStr;
  }

  public void setCodeEnuStr(String codeEnuStr) {
    this.codeEnuStr = codeEnuStr;
  }

}
