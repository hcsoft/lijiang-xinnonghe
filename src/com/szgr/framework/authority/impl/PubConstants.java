package com.szgr.framework.authority.impl;

/**
 * <p>Title: ynds</p>
 * @version 1.1
 */

public interface PubConstants {
    public static final String VALID_STATUS = "01";
    public static final String INVALID_STATUS = "00";

    // ˰����ؼ���
    public static String TAXORGCLASS_PRO = "01"; //ʡ��˰�����
    public static String TAXORGCLASS_SUP = "02"; //���м�˰�����
    public static String TAXORGCLASS_ORG = "03"; //����������
    public static String TAXORGCLASS_DEPT = "04"; //�־���˰�����

    // ˰��������
    public static String TAXORGANIZATION = "01"; //�ݣ�˰����أ�������˰����飩

    // ˰������������ͣ����ȣ���taxname or shortname��
    //˰����ؼ��
    public static String TAXORGNAME_SHORT = "short"; //��Ӧtaxorgshortname
    //˰�����ȫ��
    public static String TAXORGNAME_LONG = "long"; //��Ӧtaxorgname

    // ˰����ش�����Чλ����
    public static int TAXORGLENGTH_SUP = 4;
    public static int TAXORGLENGTH_ORG = 6;
    public static int TAXORGLENGTH_DEPT = 8;

    //�ڵ��ʶ��node  ��00�����ڵ� ��01��Ҷ�ӽڵ�
    public static final String SYS_NODE_ROOT = "00";
    public static final String SYS_NODE_LEAF = "01";

//  //ע�����ʹ���ڵ��ʶ: "0"���ڵ�  "1"Ҷ�ӽڵ�
//  public static final String ECONATURE_NODE_ROOT = "0";
//  public static final String ECONATURE_NODE_LEAF = "1";

    //˰��˰Ŀ����ڵ��ʶ: "99"˰��  "00"˰Ŀ
    public static final String TAXCODE_ROOT = "99";
    public static final String TAXCODE_LEAF = "00";
    //���ַ�Ŀ����ڵ��ʶ: "00"������  "01"���ִ���  "02"��Ŀ����
    public static final String FEETYPECODE_TYPE = "00";
    public static final String FEETYPECODE_FEE = "01";
    public static final String FEETYPECODE_FEEITEM = "02";
    //(��)��λ���ʹ���ڵ��ʶ: "00"  "01"
    public static final String FPROPERTYPECODE_FEEITEMTYPE = "00";
    public static final String FPROPERTYPECODE_TYPE = "01";


    //�ַ��Ϳ�ֵ���洢��(.)
    public static final String SYS_CHAR_NULL = ".";

    //��ֵ�Ϳ�ֵ���洢0.00
    public static double SYS_DECIMAL_NULL = 0.00;


    //��˰��״̬��ʶ
    public static String TAXPAYERSTATUS_NOMAL = "01";

    //��˰�˻���״̬
    public static String UNTAXPAYERSAUDIT_FLAG = "00";
    public static String TAXPAYERSAUDIT_FLAG = "01";
    //��˰��"�Կ����˷�Ʊ"��ʶ
    public static String TAXPAYER_FREIGHTSELFFLAG = "01";
    //��˰��"�������˷�Ʊ"��ʶ
    public static String TAXPAYER_FREIGHTSUPPLYFLAG = "01";
    //ͣҵ������־
    public static String STOP_FLAG = "00";
    public static String STOPEND_FLAG = "01";
    //��ҵ������־
    public static String RESTORE_FLAG = "00";
    public static String RESTOREEND_FLAG = "01";
    //ע��������־
    public static String CANCEL_FLAG = "00";
    public static String CANCELEND_FLAG = "01";

    //��˰�˼��״̬
    public static String UNTAXPAYERSCHECK_FLAG = "00";
    public static String TAXPAYERSCHECK_FLAG = "01";

    /*************add by liuwanfu begain**************/
    //˰����Ա����
    //�쵼
    public static String TAXEMPCODE_AUTH_TYPE = "10";
    //������Ա
    public static String TAXEMPCODE_LEVY_TYPE = "20";
    //˰�չ���Ա
    public static String TAXEMPCODE_TAXMANAGER_TYPE = "30";


    //˰����Ա��ʶ
    //�쵼��ʶ
    public static String TAXEMPCODE_AUTH_FLAG = "01";
    //������Ա��ʶ
    public static String TAXEMPCODE_LEVY_FLAG = "01";
    //ר��Ա��ʶ
    public static String TAXEMPCODE_TAXMANAGER_FLAG = "01";

    /*************add by liuwanfu end**************/

    /*
     * ������cacheʹ�õĳ��� END
     */
    /**
     * ������Ϣ�������ʶ���Ǽ�����鹲��
     */
    //�ǼǱ�ʶΪ10
    public static String MGR_PUNISHINFO_OPERATEFLAG_TAXREG = "10";
    //�����ʶΪ20
    public static String MGR_PUNISHINFO_OPERATEFLAG_TAXAUDIT = "20";


    /**
     * �����Ǽ�״̬��ʶ��ϵͳ������
     * by����
     */
    //�����Ǽ�״̬����ɣ�
    public static String REG_TAXREGSTATUS_FINISHED = "01";
    //�����Ǽ�״̬��δ��ɣ�
    public static String REG_TAXREGSTATUS_UNFINISHED = "00";

    /**
     *���տ�����: 01--��Ʊ��֤��  02--Ԥ��˰�֤��  03--������
     * add by wangbangcai
     */
    public static final String TMPAMOUNTCODE_INVPAY = "01";
    public static final String TMPAMOUNTCODE_PREPAY = "02";
    public static final String TMPAMOUNTCODE_SALEPAY = "03";
}
