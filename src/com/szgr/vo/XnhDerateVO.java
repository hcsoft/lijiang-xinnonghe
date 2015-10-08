package com.szgr.vo;

//imports
import java.lang.StringBuffer;
import java.math.BigDecimal;
import java.lang.String;
import java.util.Date;
import java.io.Serializable;

/**
* <p>Title:xnh_derate </p>
* <p>Description: xnh_derate,Hibernate 映射VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2015-10-03 11:54:00.55
*/

public class XnhDerateVO implements Serializable, Cloneable {
    //Fields
    //serialno
    private java.lang.String serialno;
    //user_id
    private java.lang.String user_id;
    //union_id
    private java.lang.String union_id;
    //card_id
    private java.lang.String card_id;
    //住院起时间
    private java.util.Date hospital_begindate;
    //住院止时间
    private java.util.Date hospital_enddate;
    //诊断
    private java.lang.String diagnose;
    //减免类型
    private java.lang.String derate_type;
    //减免日期
    private java.util.Date derate_date;
    //实际医疗费用
    private java.math.BigDecimal actual_amount;
    //减免金额
    private java.math.BigDecimal derate_amount;
    //累计减免金额
    private java.math.BigDecimal derate_sumamount;
    //医生
    private java.lang.String doctor;
    //医疗机构
    private java.lang.String opt_orgcode;
    //opt_empcode
    private java.lang.String opt_empcode;
    //optdate
    private java.util.Date optdate;
    
    private int muteFlag;
    
	//contructors
    public XnhDerateVO() {}

    public XnhDerateVO(java.lang.String serialno) {
        this.serialno = serialno;
    }

	//methods
    public java.lang.String getSerialno() {
        return this.serialno;
    }

    public void setSerialno(java.lang.String serialno) {
        this.serialno = serialno;
    }

    public java.lang.String getUser_id() {
        return this.user_id;
    }

    public void setUser_id(java.lang.String user_id) {
        this.user_id = user_id;
    }

    public java.lang.String getUnion_id() {
        return this.union_id;
    }

    public void setUnion_id(java.lang.String union_id) {
        this.union_id = union_id;
    }

    public java.lang.String getCard_id() {
        return this.card_id;
    }

    public void setCard_id(java.lang.String card_id) {
        this.card_id = card_id;
    }

    public java.util.Date getHospital_begindate() {
        return this.hospital_begindate;
    }

    public void setHospital_begindate(java.util.Date hospital_begindate) {
        this.hospital_begindate = hospital_begindate;
    }

    public java.util.Date getHospital_enddate() {
        return this.hospital_enddate;
    }

    public void setHospital_enddate(java.util.Date hospital_enddate) {
        this.hospital_enddate = hospital_enddate;
    }

    public java.lang.String getDiagnose() {
        return this.diagnose;
    }

    public void setDiagnose(java.lang.String diagnose) {
        this.diagnose = diagnose;
    }

    public java.lang.String getDerate_type() {
        return this.derate_type;
    }

    public void setDerate_type(java.lang.String derate_type) {
        this.derate_type = derate_type;
    }

    public java.util.Date getDerate_date() {
        return this.derate_date;
    }

    public void setDerate_date(java.util.Date derate_date) {
        this.derate_date = derate_date;
    }

    public java.math.BigDecimal getActual_amount() {
        return this.actual_amount;
    }

    public void setActual_amount(java.math.BigDecimal actual_amount) {
        this.actual_amount = actual_amount;
    }

    public java.math.BigDecimal getDerate_amount() {
        return this.derate_amount;
    }

    public void setDerate_amount(java.math.BigDecimal derate_amount) {
        this.derate_amount = derate_amount;
    }

    public java.math.BigDecimal getDerate_sumamount() {
        return this.derate_sumamount;
    }

    public void setDerate_sumamount(java.math.BigDecimal derate_sumamount) {
        this.derate_sumamount = derate_sumamount;
    }

    public java.lang.String getDoctor() {
        return this.doctor;
    }

    public void setDoctor(java.lang.String doctor) {
        this.doctor = doctor;
    }

    public java.lang.String getOpt_orgcode() {
        return this.opt_orgcode;
    }

    public void setOpt_orgcode(java.lang.String opt_orgcode) {
        this.opt_orgcode = opt_orgcode;
    }

    public java.lang.String getOpt_empcode() {
        return this.opt_empcode;
    }

    public void setOpt_empcode(java.lang.String opt_empcode) {
        this.opt_empcode = opt_empcode;
    }

    public java.util.Date getOptdate() {
        return this.optdate;
    }

    public void setOptdate(java.util.Date optdate) {
        this.optdate = optdate;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[user_id:").append(user_id).append("]");
        sb.append("[union_id:").append(union_id).append("]");
        sb.append("[card_id:").append(card_id).append("]");
        sb.append("[hospital_begindate:").append(hospital_begindate).append("]");
        sb.append("[hospital_enddate:").append(hospital_enddate).append("]");
        sb.append("[diagnose:").append(diagnose).append("]");
        sb.append("[derate_type:").append(derate_type).append("]");
        sb.append("[derate_date:").append(derate_date).append("]");
        sb.append("[actual_amount:").append(actual_amount).append("]");
        sb.append("[derate_amount:").append(derate_amount).append("]");
        sb.append("[derate_sumamount:").append(derate_sumamount).append("]");
        sb.append("[doctor:").append(doctor).append("]");
        sb.append("[opt_orgcode:").append(opt_orgcode).append("]");
        sb.append("[opt_empcode:").append(opt_empcode).append("]");
        sb.append("[optdate:").append(optdate).append("]");
        return sb.toString();
    }

    public int hashCode() {
        int result = 0;
        result = 29 * result + (serialno == null ? 0 : serialno.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof XnhDerateVO))
            return false;
        XnhDerateVO eq = (XnhDerateVO)vo;
        return serialno == null ? eq.getSerialno() == null : serialno.equals(eq.getSerialno());
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}