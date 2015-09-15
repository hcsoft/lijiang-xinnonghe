package com.szgr.util.fileexport;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;

/**
 * �����ж���ʵ��
 * @author �ܽ�
 * @version 1.0
 */
public class ColumnEntry {

  //��������
  private String englishName;

  //������
  private String chineseName = "������";

  //��������ƣ�����ö��ֵ�ַ���

  private String codeEnuStr;

  //��Ԫ��ʽ����
  private HSSFCellStyle cellStyle =null;

  //��������
  private int datatype = 1;
  ;

  public ColumnEntry() {
  }
  /**
   * ���캯��
   * @param chineseName String ������
   * @param englishName String Ӣ����
   */
  public ColumnEntry(String chineseName, String englishName) {
    this.chineseName = chineseName;
    this.englishName = englishName;
  }
  /**
   * ���캯����Ŀǰ��ʹ��
   * @param chineseName String������
   * @param englishName String Ӣ����
   * @param datatype int ��������
   * @param codeorEnuStr String ����������ƻ���ö���ַ���
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
   * ��ȡ����Ĭ���ж���
   * @return ColumnEntry
   */
  public static ColumnEntry getColumnEntryInstance() {

    return new ColumnEntry();
  }

  /**
   * ��ȡ����Ĭ���ж���
   * @param chineseName String
   * @param englishName String
   * @return ColumnEntry
   */
  public static ColumnEntry getColumnEntryInstance(String chineseName,
      String englishName) {

    return new ColumnEntry(chineseName, englishName);
  }
  /**
   * ��ȡColumnEntry����,Ŀǰ��ʹ��
   * @param chineseName String������
   * @param englishName String Ӣ����
   * @param datatype int ��������
   * @param codeorEnuStr String ����������ƻ���ö���ַ���
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
