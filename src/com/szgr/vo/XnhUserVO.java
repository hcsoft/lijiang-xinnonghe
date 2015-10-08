package com.szgr.vo;

//imports
import java.lang.StringBuffer;
import java.lang.Integer;
import java.lang.String;
import java.util.Date;
import java.io.Serializable;

/**
* <p>Title:xnh_user </p>
* <p>Description: xnh_user,Hibernate 映射VO </p>
* <p>Company: thtf yun nan Branch</p>
* @author PdmToVoGen1.0 
* @version 1.0
* @create datetime 2015-09-24 09:37:33.564
*/

public class XnhUserVO implements Serializable, Cloneable {
    //Fields
    //user_id
    private java.lang.String user_id;
    //合作医疗证号
    private java.lang.String union_id;
    //卡号
    private java.lang.String card_id;
    //个人编号
    private java.lang.String person_no;
    //姓名
    private java.lang.String user_name;
    //gender
    private java.lang.String gender;
    //birthday
    private java.util.Date birthday;
    //age
    private java.lang.Integer age;
    //idnumber
    private java.lang.String idnumber;
    //province
    private java.lang.String province;
    //city
    private java.lang.String city;
    //area
    private java.lang.String area;
    //乡镇
    private java.lang.String town;
    //村
    private java.lang.String village;
    //小组
    private java.lang.String team;
    //address
    private java.lang.String address;
    //telephone
    private java.lang.String telephone;
    //pic
    private java.lang.String pic;
    //行政区划id
    private java.lang.String org_code;
    //leader_flag
    private java.lang.String leader_flag;
    //leader_id
    private java.lang.String leader_id;
    //leader_relation
    private java.lang.String leader_relation;
    //角色属性
    private java.lang.String role_id;
    //缴费档次
    private java.lang.String pay_level;
    //hospital_id
    private java.lang.String hospital_id;
    //valid
    private java.lang.String valid;
    
    private int muteFlag;
    
	//contructors
    public XnhUserVO() {}

    public XnhUserVO(java.lang.String user_id) {
        this.user_id = user_id;
    }

	//methods
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

    public java.lang.String getPerson_no() {
        return this.person_no;
    }

    public void setPerson_no(java.lang.String person_no) {
        this.person_no = person_no;
    }

    public java.lang.String getUser_name() {
        return this.user_name;
    }

    public void setUser_name(java.lang.String user_name) {
        this.user_name = user_name;
    }

    public java.lang.String getGender() {
        return this.gender;
    }

    public void setGender(java.lang.String gender) {
        this.gender = gender;
    }

    public java.util.Date getBirthday() {
        return this.birthday;
    }

    public void setBirthday(java.util.Date birthday) {
        this.birthday = birthday;
    }

    public java.lang.Integer getAge() {
        return this.age;
    }

    public void setAge(java.lang.Integer age) {
        this.age = age;
    }

    public java.lang.String getIdnumber() {
        return this.idnumber;
    }

    public void setIdnumber(java.lang.String idnumber) {
        this.idnumber = idnumber;
    }

    public java.lang.String getProvince() {
        return this.province;
    }

    public void setProvince(java.lang.String province) {
        this.province = province;
    }

    public java.lang.String getCity() {
        return this.city;
    }

    public void setCity(java.lang.String city) {
        this.city = city;
    }

    public java.lang.String getArea() {
        return this.area;
    }

    public void setArea(java.lang.String area) {
        this.area = area;
    }

    public java.lang.String getTown() {
        return this.town;
    }

    public void setTown(java.lang.String town) {
        this.town = town;
    }

    public java.lang.String getVillage() {
        return this.village;
    }

    public void setVillage(java.lang.String village) {
        this.village = village;
    }

    public java.lang.String getTeam() {
        return this.team;
    }

    public void setTeam(java.lang.String team) {
        this.team = team;
    }

    public java.lang.String getAddress() {
        return this.address;
    }

    public void setAddress(java.lang.String address) {
        this.address = address;
    }

    public java.lang.String getTelephone() {
        return this.telephone;
    }

    public void setTelephone(java.lang.String telephone) {
        this.telephone = telephone;
    }

    public java.lang.String getPic() {
        return this.pic;
    }

    public void setPic(java.lang.String pic) {
        this.pic = pic;
    }

    public java.lang.String getOrg_code() {
        return this.org_code;
    }

    public void setOrg_code(java.lang.String org_code) {
        this.org_code = org_code;
    }

    public java.lang.String getLeader_flag() {
        return this.leader_flag;
    }

    public void setLeader_flag(java.lang.String leader_flag) {
        this.leader_flag = leader_flag;
    }

    public java.lang.String getLeader_id() {
        return this.leader_id;
    }

    public void setLeader_id(java.lang.String leader_id) {
        this.leader_id = leader_id;
    }

    public java.lang.String getLeader_relation() {
        return this.leader_relation;
    }

    public void setLeader_relation(java.lang.String leader_relation) {
        this.leader_relation = leader_relation;
    }

    public java.lang.String getRole_id() {
        return this.role_id;
    }

    public void setRole_id(java.lang.String role_id) {
        this.role_id = role_id;
    }

    public java.lang.String getPay_level() {
        return this.pay_level;
    }

    public void setPay_level(java.lang.String pay_level) {
        this.pay_level = pay_level;
    }

    public java.lang.String getHospital_id() {
        return this.hospital_id;
    }

    public void setHospital_id(java.lang.String hospital_id) {
        this.hospital_id = hospital_id;
    }

    public java.lang.String getValid() {
        return this.valid;
    }

    public void setValid(java.lang.String valid) {
        this.valid = valid;
    }

    public void setMuteFlag(int muteFlag) {
        this.muteFlag = muteFlag;
    }

    public int getMuteFlag() {
        return muteFlag;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[union_id:").append(union_id).append("]");
        sb.append("[card_id:").append(card_id).append("]");
        sb.append("[person_no:").append(person_no).append("]");
        sb.append("[user_name:").append(user_name).append("]");
        sb.append("[gender:").append(gender).append("]");
        sb.append("[birthday:").append(birthday).append("]");
        sb.append("[age:").append(age).append("]");
        sb.append("[idnumber:").append(idnumber).append("]");
        sb.append("[province:").append(province).append("]");
        sb.append("[city:").append(city).append("]");
        sb.append("[area:").append(area).append("]");
        sb.append("[town:").append(town).append("]");
        sb.append("[village:").append(village).append("]");
        sb.append("[team:").append(team).append("]");
        sb.append("[address:").append(address).append("]");
        sb.append("[telephone:").append(telephone).append("]");
        sb.append("[pic:").append(pic).append("]");
        sb.append("[org_code:").append(org_code).append("]");
        sb.append("[leader_flag:").append(leader_flag).append("]");
        sb.append("[leader_id:").append(leader_id).append("]");
        sb.append("[leader_relation:").append(leader_relation).append("]");
        sb.append("[role_id:").append(role_id).append("]");
        sb.append("[pay_level:").append(pay_level).append("]");
        sb.append("[hospital_id:").append(hospital_id).append("]");
        sb.append("[valid:").append(valid).append("]");
        return sb.toString();
    }

    public int hashCode() {
        int result = 0;
        result = 29 * result + (user_id == null ? 0 : user_id.hashCode());
        return result;
    }

    public boolean equals(Object vo) {
        if(this == vo)
            return true;
        if(!(vo instanceof XnhUserVO))
            return false;
        XnhUserVO eq = (XnhUserVO)vo;
        return user_id == null ? eq.getUser_id() == null : user_id.equals(eq.getUser_id());
    }

    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}