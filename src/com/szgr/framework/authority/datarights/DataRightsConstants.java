package com.szgr.framework.authority.datarights;

public class DataRightsConstants {
  private DataRightsConstants() {
  }
  //������������
  //ʡ��
  public final static  String  ORGANAZITIONLEVL01= "01";
 //�м�
  public final static  String ORGANAZITIONLEVL02 = "02";
  //������
  public final static  String ORGANAZITIONLEVL03 = "03";
  //�־���������Ȩ��
   public final static  String ORGANAZITIONLEVL04 = "04";

   //���м���˰����
   public final static String TAXORGSUPCODE = "taxorgsupcode";
   //��˰����
   public final static String TAXORGCODE = "taxorgcode";
   //��˰����
   public final static String TAXDEPTCODE = "taxdeptcode";
   //���ջ���
   public final static String TAXLEVYORGCODE ="taxlevyorgcode";
   //˰�չ���Ա
   public final static String TAXMANAGERCODE ="taxmanagercode";

   /**
    * 04����־����Ļ������ͷ�Ϊ���ջ��أ��������,���չ����������
    */
   //���ջ���
   public final static String LEVYORGTYPE  ="01";
   //�������
   public final static String MANAGERORGTYPE ="02";
   //���չ������
   public final static String LEVYMAGORGTYPE ="03";


   //���������б�Ȩ�޵ļ��ֿ��ܵ�ͨ���
    //ʡ�������б�Ȩ��
    public final static String RIGHTTYPE01 ="#allright#";
    //�м������б�Ȩ��
    public final static String RIGHTTYPE02 = "#taxorgsupright#";
    //�����������б�Ȩ��
    public final static String RIGHTTYPE03 = "#taxorgright#";
    //�־���Ȩ��
    public final static String RIGHTTYPE04 = "#taxdeptright#";




   //ʡ������Ȩ������
  //�մ�
  //�м�����Ȩ��
  //userrights������usertaxorgcode��taxorgsupcode��ֵ
  //���ܵ�����Ϊ
  //1���մ�
  //2��taxorgsupcode = {user.taxorgsupcode} or taxorgsupcode in ('5301','5012')
  //����������Ȩ
  //userrights������usertaxorgcode��taxorgsupcode��taxorgcode��ֵ
  //1���մ�
  //2��taxorgsupcode = {user.taxorgsupcode} or taxorgsupcode in('5301','5012')
  //3��taxorgcode = {user.taxorgcode} or taxorgcode in ('5301124','53012264')
  //�־���Ȩ��
  //userrights������usertaxorgcode��taxorgsupcode��taxorgcode��taxdeptcode��ֵ
  //1���մ�
  //2��taxorgsupcode = {user.taxorgsupcode} or taxorgsupcode in('5301','5012')
  //3��taxorgcode = {user.taxorgcode} or taxorgcode in ('5301124','53012264')
  //4��taxdeptcode = {user.taxdeptcode} or taxdeptcode in ('2333','22222')
  //����Ȩ��5��taxlevyorgcode ={user.taxdeptcode} or
  /**
   * ��ʶ����Ϊ�յĳ����ַ�
   */
  public static final String NOVALUE ="#null#";

  /**
   * ���ܵ�����Ȩ������ͨ���
   */
  /** @todo �û���taxorgcode �������¹ؼ��ֶ� */
  //�м�����
  public final static String USER_TAXORGSUPCODE ="#user.taxorgsupcode#";
  //����������
  public final static String USER_TAXORGCODE ="#user.taxorgcode#";
  //�־���
  public final static String USER_TAXDEPTCODE ="#user.taxdeptcode#";
  //˰�չ���Ա
  public final static String USER_TAXMANAGERCODE ="#user.taxmanagercode#";

  //���ջ���Ȩ�������õģ�ͨ�ó��򲻽��д���ֻ�ṩ��������Ȩ�޷��ʵķ���
  //���������{user.taxlevyorgcode}
}
